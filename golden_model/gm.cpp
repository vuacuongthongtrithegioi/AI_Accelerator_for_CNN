#include <iostream>
#include <queue>
using namespace std;

struct InputBuffer {
    int rA[3][3];
    int rB[3][3];

    void load(int A[3][3], int B[3][3]) {
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++) {
                rA[i][j] = A[i][j];
                rB[i][j] = B[i][j];
            }
    }

    void get(int cycle, int &a1, int &a2, int &a3,
                         int &b1, int &b2, int &b3) {

        switch (cycle) {
            case 1:
                a1 = rA[0][0]; a2 = 0;         a3 = 0;
                b1 = rB[0][0]; b2 = 0;         b3 = 0;
                break;

            case 2:
                a1 = rA[0][1]; a2 = rA[1][0];  a3 = 0;
                b1 = rB[1][0]; b2 = rB[0][1];  b3 = 0;
                break;

            case 3:
                a1 = rA[0][2]; a2 = rA[1][1];  a3 = rA[2][0];
                b1 = rB[2][0]; b2 = rB[1][1];  b3 = rB[0][2];
                break;

            case 4:
                a1 = 0;         a2 = rA[1][2]; a3 = rA[2][1];
                b1 = 0;         b2 = rB[2][1]; b3 = rB[1][2];
                break;

            case 5:
                a1 = 0; a2 = 0; a3 = rA[2][2];
                b1 = 0; b2 = 0; b3 = rB[2][2];
                break;

            default:
                a1 = a2 = a3 = 0;
                b1 = b2 = b3 = 0;
        }
    }
};

struct PE {
    long long psum = 0;

    void compute(int a, int b) {
        psum += (long long)a * b;
    }
};

class Systolic3x3 {
public:
    PE pe[3][3];

    int a_reg[3][3] = {};
    int b_reg[3][3] = {};

    void step(int a1, int a2, int a3,
              int b1, int b2, int b3) {

        for (int i = 0; i < 3; i++)
            for (int j = 2; j > 0; j--)
                a_reg[i][j] = a_reg[i][j-1];

        for (int j = 0; j < 3; j++)
            for (int i = 2; i > 0; i--)
                b_reg[i][j] = b_reg[i-1][j];

        a_reg[0][0] = a1;
        a_reg[1][0] = a2;
        a_reg[2][0] = a3;

        b_reg[0][0] = b1;
        b_reg[0][1] = b2;
        b_reg[0][2] = b3;

        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                pe[i][j].compute(a_reg[i][j], b_reg[i][j]);
    }

    void print_psum() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++)
                cout << pe[i][j].psum << "\t";
            cout << endl;
        }
    }
};

class Pipe {
public:
    int process(long long x) {
        return (int)(x >> 8);
    }
};

class ReLU {
public:
    int activate(int x) {
        return (x > 0) ? x : 0;
    }
};

class FIFO {
public:
    queue<int> q;

    void push(int x) { q.push(x); }
    int pop() { int x = q.front(); q.pop(); return x; }
    bool empty() { return q.empty(); }
};

class OutputBuffer {
public:
    int out[3][3];

    void store(int idx, int val) {
        int i = idx / 3;
        int j = idx % 3;
        out[i][j] = val;
    }

    void print() {
        cout << "\n=== FINAL OUTPUT MATRIX ===\n";
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++)
                cout << out[i][j] << "\t";
            cout << endl;
        }
    }
};

int main() {

    int A[3][3] = {
        {1,2,3},
        {4,5,6},
        {7,8,9}
    };

    int B[3][3] = {
        {1,2,3},
        {4,5,6},
        {7,8,9}
    };

    InputBuffer ib;
    Systolic3x3 sa;
    Pipe pipe;
    ReLU relu;
    FIFO fifo;
    OutputBuffer ob;

    ib.load(A, B);

    cout << "=== NPU Simulation Start ===\n";

    for (int cycle = 1; cycle <= 7; cycle++) {

        int a1,a2,a3,b1,b2,b3;
        ib.get(cycle, a1,a2,a3, b1,b2,b3);

        cout << "\nCycle " << cycle << endl;
        cout << "A_in: " << a1 << "," << a2 << "," << a3 << endl;
        cout << "B_in: " << b1 << "," << b2 << "," << b3 << endl;

        sa.step(a1,a2,a3,b1,b2,b3);

        cout << "PSUM:\n";
        sa.print_psum();
    }

    cout << "\n=== Pipe + ReLU + FIFO ===\n";

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {

            long long raw = sa.pe[i][j].psum;

            int after_pipe = pipe.process(raw);
            int after_relu = relu.activate(after_pipe);

            fifo.push(after_relu);
        }
    }

    int idx = 0;
    while (!fifo.empty()) {
        ob.store(idx++, fifo.pop());
    }

    ob.print();

    return 0;
}