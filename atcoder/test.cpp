#include <bits/stdc++.h>
#include <atcoder/all>
using namespace std;
using namespace atcoder;

int main() {
    string s = "missisippi";

    vector<int> sa = suffix_array(s);

    vector<string> answer = {
        "i",
        "ippi",
        "isippi",
        "issisippi",
        "missisippi",
        "pi",
        "ppi",
        "sippi",
        "sisippi",
        "ssisippi",
    };

    assert(sa.size() == answer.size());
    for(int i = 0; i < int(sa.size()); i++) {
        assert(s.substr(sa[i]) == answer[i]);
        cout << s.substr(sa[i]) << "\t\t" << answer[i] << "\n";
    }
    return 0;
}
