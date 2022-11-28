#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>

using namespace std;

int main() {
    int val1, val2;
    cin >> val1 >> val2;
    vector< vector<int> > a = {
        {1, 3, 7}, // => 11
        {2, 3, 4, val1}, // -10 => -1
        {9, 8, 15}, // => 32
        {10, val2}, // -5 => 5
    };

    //# sắp xếp các vector trong a theo tổng các phần tử giảm dần
    // sort(a.begin(), a.end(), [] (vector<int> a, vector<int> b) -> bool {
    //     return accumulate(a.begin(), a.end(), 0) > accumulate(b.begin(), b.end(), 0);
    // });

    sort(a.begin(), a.end(), [] (vector<int> a, vector<int> b) -> bool {
        int s1=0, s2=0;
        for (auto x : a) s1 += x;
        for (auto x : b) s2 += x;
        return s1 > s2;
    });

    for (const auto &v : a) {
        for (int it : v) {
            cout << it << ' ';
        }
        cout << endl;
    }
    return 0;
}