#include <iostream>
#include <ostream>
#include <math.h>
#include <iomanip> 

using namespace std;

struct Complex {
    double real;
    double imag;
};

Complex operator + (Complex a, Complex b) {
    double r = a.real + b.real;
    double i = a.imag + b.imag;
    return Complex {r, i};
}

Complex operator - (Complex a, Complex b) {
    double r = a.real - b.real;
    double i = a.imag - b.imag;
    return Complex {r, i};
}

Complex operator * (Complex a, Complex b) {
    double r = a.real*b.real - a.imag*b.imag;
    double i = a.real*b.imag + a.imag*b.real;
    return Complex {r, i};
}

Complex operator / (Complex a, Complex b) {
    double r = (a.real*b.real + a.imag*b.imag) / (b.real*b.real + b.imag*b.imag);
    double i = (a.imag*b.real - a.real*b.imag) / (b.real*b.real + b.imag*b.imag);
    return Complex {r, i};
}

ostream& operator << (ostream& out, const Complex &a) {
    out << '(' << std::setprecision(2) << a.real << (a.imag >= 0 ? '+' : '-') << std::setprecision(2) << fabs(a.imag) << 'i' << ')';
    return out;
}

int main() {
    double real_a, real_b, img_a, img_b;
    cin >> real_a >> img_a;
    cin >> real_b >> img_b;
    
    Complex a{real_a, img_a};
    Complex b{real_b, img_b};
    
    cout << a << " + " << b << " = " << a + b << endl;
    cout << a << " - " << b << " = " << a - b << endl;
    cout << a << " * " << b << " = " << a * b << endl;
    cout << a << " / " << b << " = " << a / b << endl;
    
    return 0;
}
