#include <iostream>
using namespace std;

//# viết hàm arr_sum
template <typename T>
T arr_sum(T arr1[], int len1, T arr2[], int len2) {
    T sum=0;
    while (--len1 >= 0) sum += arr1[len1];
    while (--len2 >= 0) sum += arr2[len2];
    return sum;
}

int main() {
    int val;
    cin >> val;
    
    {
        int a[] = {3, 2, 0, val};
        int b[] = {5, 6, 1, 2, 7};
        cout << arr_sum(a, 4, b, 5) << endl;
    }
    {
        double a[] = {3.0, 2, 0, val * 1.0};
        double b[] = {5, 6.1, 1, 2.3, 7};
        cout << arr_sum(a, 4, b, 5) << endl;
    }

    return 0;
}