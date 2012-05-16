#include <iostream>
#include <cmath>

#define DEBUG

#ifndef DEBUG
    #define ASSERT(x)
#else
    #define ASSERT(x) \
        if (! (x)) \
            { \
                cout << "ERROR!! Assert " << #x << " failed\n"; \
                cout << " on line " << __LINE__  << "\n"; \
                cout << " in file " << __FILE__ << "\n";  \
            }
#endif


using namespace std;


typedef double VTYPE;

class GVector {
    public:
    GVector() : _x(0.0), _y(0.0) {}
    GVector(VTYPE ix, VTYPE iy) : _x(ix), _y(iy) {}

    VTYPE x() { return _x; }
    VTYPE y() { return _y; }
    GVector plus(GVector other) { return GVector(_x + other.x(), _y + other.y()); }
    GVector minus(GVector other) { return GVector(_x - other.x(), _y - other.y()); }
    VTYPE min() { return ((_x < _y) ? _x : _y);}
    VTYPE max() { return ((_x < _y) ? _y : _x);}
    int sort_comparison(GVector other) {
        if (_x < other.x()) {
            return -1;
        } else if (_x > other.x()) {
            return 1;
        }

        if (_y < other.y()) {
            return -1;
        } else if (_y > other.y()) {
            return 1;
        }

        return 0;
    }
    VTYPE sum2d() { return _x + _y; }
    VTYPE dot(GVector other) { return (_x * other.x()) + (_y * other.y()); }
    VTYPE norm() { return sqrt((_x * _x) + (_y * _y)); }
    GVector scale(VTYPE s) { return GVector(_x * s, _y * s); }
    VTYPE distance_from(GVector other) {
        GVector v = this->minus(other);

        return v.norm();
    }
    GVector unit() {
        VTYPE n = this->norm();
        if (n == 0) return *this; // TODO should really duplicate this and/or raise error

        return this->scale(1.0/n);
    }

    private:
    VTYPE _x, _y;
};

int main()
{
    GVector a(1.0, 2.0);
    GVector b;
    GVector c(-3.0, -5.0);
    GVector d(1.0, 3.0);
    GVector e(1.0, 1.0);
    GVector f(1.0, -1.0);
    { // Constructor Tests
        ASSERT(a.x() == 1.0d);
        ASSERT(a.y() == 2.0d);
        ASSERT(b.x() == 0.0d);
        ASSERT(b.y() == 0.0d);
    }

    { // Adding Zero Tests
        GVector sum_zero = a.plus(b);
        ASSERT(sum_zero.x() == 1.0d);
        ASSERT(sum_zero.y() == 2.0d);
    }
    { // Adding  Tests
        GVector sum = a.plus(a);
        ASSERT(sum.x() == 2.0d);
        ASSERT(sum.y() == 4.0d);
    }
    { // Subtracting  Tests
        GVector diffz = a.minus(a);
        ASSERT(diffz.x() == 0.0d);
        ASSERT(diffz.y() == 0.0d);

        GVector diff = a.minus(c);
        ASSERT(diff.x() == 4.0d);
        ASSERT(diff.y() == 7.0d);
    }
    { // Min  Tests
        ASSERT(a.min() == 1.0d);
        ASSERT(b.min() == 0.0d);
        ASSERT(c.min() == -5.0d);
    }
    { // Max  Tests
        ASSERT(a.max() == 2.0d);
        ASSERT(b.max() == 0.0d);
        ASSERT(c.max() == -3.0d);
    }
    { // Comparison  Tests
        ASSERT(a.sort_comparison(a) == 0);
        ASSERT(b.sort_comparison(b) == 0);
        ASSERT(c.sort_comparison(c) == 0);

        ASSERT(a.sort_comparison(b) == 1);
        ASSERT(a.sort_comparison(c) == 1);

        ASSERT(a.sort_comparison(d) == -1);
        ASSERT(a.sort_comparison(e) == 1);
    }
    { // Sum2d Tests
        ASSERT(a.sum2d() == 3.0);
        ASSERT(b.sum2d() == 0.0);
        ASSERT(c.sum2d() == -8.0);
        ASSERT(d.sum2d() == 4.0);
        ASSERT(e.sum2d() == 2.0);
    }
    { // Dot Tests
        ASSERT(a.dot(a) == 5.0);
        ASSERT(a.dot(b) == 0.0);
        ASSERT(a.dot(e) == 3.0);
        ASSERT(a.dot(c) == -13.0);
    }
    { // Norm Tests
        GVector rnd1(0.0, 3.0);
        ASSERT(rnd1.norm() == 3.0);
        ASSERT(a.norm() == sqrt(5.0));
    }
    { // Unit Tests
        GVector three(0.0, 3.0);
        GVector u = three.unit();
        ASSERT(u.x() == 0.0);
        ASSERT(u.y() == 1.0);
    }
    { // Scale Tests
        GVector a2 = a.scale(2.0);
        GVector a3 = a.scale(3.0);
        ASSERT(a2.x() == 2.0);
        ASSERT(a2.y() == 4.0);
        ASSERT(a3.x() == 3.0);
        ASSERT(a3.y() == 6.0);
    }
    { // Distance From Tests
        ASSERT(a.distance_from(f) == 3.0);
        ASSERT(a.distance_from(a) == 0.0);
    }






    cout << "Hello world!" << endl;
    return 0;
}
