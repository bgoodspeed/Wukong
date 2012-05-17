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
typedef void * UDATA_TYPE;

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

namespace Primitives {
    class Circle {
        public:
        Circle(GVector position, VTYPE radius) : _position(position), _radius(radius) , _user_data(NULL) { }
        Circle(GVector position, VTYPE radius, UDATA_TYPE userdata) : _position(position), _radius(radius), _user_data(userdata) {}
        VTYPE radius() { return _radius; }
        GVector position() { return _position; }
        std::string collision_response_type() { return "Circle"; }
        std::string collision_type() { return "Circle"; }
        Circle to_collision() { return *this; }
        UDATA_TYPE user_data() { return _user_data;}
        private:
        GVector _position;
        VTYPE _radius;
        UDATA_TYPE _user_data;
    };

    class LineSegment {
        public:
        LineSegment(GVector p1, GVector p2) : _p1(p1), _p2(p2) {}
        VTYPE sx() { return _p1.x(); }
        VTYPE sy() { return _p1.y(); }
        VTYPE ex() { return _p2.x(); }
        VTYPE ey() { return _p2.y(); }
        GVector p1() { return _p1; }
        GVector p2() { return _p2; }
        std::string collision_response_type() { return "LineSegment"; }
        std::string collision_type() { return "LineSegment"; }
        LineSegment to_collision() { return *this; }

        private:
        GVector _p1, _p2;

    };
    class Rectangle {
        public:
        Rectangle(GVector p1, GVector p2, GVector p3, GVector p4) : _p1(p1), _p2(p2),_p3(p3), _p4(p4) {
            _left = p1.x();
            _left = (_left < p2.x()) ? _left : p2.x();
            _left = (_left < p3.x()) ? _left : p3.x();
            _left = (_left < p4.x()) ? _left : p4.x();
            _right = p1.x();
            _right = (_right > p2.x()) ? _right : p2.x();
            _right = (_right > p3.x()) ? _right : p3.x();
            _right = (_right > p4.x()) ? _right : p4.x();
            _top = p1.y();
            _top = (_top > p2.y()) ? _top : p2.y();
            _top = (_top > p3.y()) ? _top : p3.y();
            _top = (_top > p4.y()) ? _top : p4.y();
            _bottom = p1.y();
            _bottom = (_bottom < p2.y()) ? _bottom : p2.y();
            _bottom = (_bottom < p3.y()) ? _bottom : p3.y();
            _bottom = (_bottom < p4.y()) ? _bottom : p4.y();
        }
        GVector p1() { return _p1; }
        GVector p2() { return _p2; }
        GVector p3() { return _p3; }
        GVector p4() { return _p4; }
        VTYPE left() { return _left; }
        VTYPE right() { return _right; }
        VTYPE bottom() { return _bottom; }
        VTYPE top() { return _top; }
        std::string collision_response_type() { return "Rectangle"; }
        std::string collision_type() { return "Rectangle"; }
        Rectangle to_collision() { return *this; }

        private:
        GVector _p1, _p2, _p3, _p4;
        VTYPE _left, _right, _top, _bottom;

    };
    class Triangle {
        public:
        Triangle(GVector p1, GVector p2, GVector p3) : _p1(p1), _p2(p2),_p3(p3) {}
        GVector p1() { return _p1; }
        GVector p2() { return _p2; }
        GVector p3() { return _p3; }
        std::string collision_response_type() { return "Triangle"; }
        std::string collision_type() { return "Triangle"; }
        Triangle to_collision() { return *this; }

        private:
        GVector _p1, _p2, _p3;

    };
}



int main()
{
    { // GVector tests
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
    }

    {   // Circle Tests
        GVector circle_pos(10, 5);
        Primitives::Circle circle(circle_pos, 3);
        { // Circle position and radius Tests
            ASSERT(circle.radius() == 3);
            ASSERT(circle_pos.x() == circle.position().x());
            ASSERT(circle_pos.y() == circle.position().y());
        }
        { // User Data Tests
            std::string userdata = "Foo";
            Primitives::Circle ud(circle_pos, 1, &userdata);

            ASSERT(circle.user_data() == NULL);
            ASSERT(ud.user_data() != NULL);
        }
        { // Collision Type Tests
            ASSERT(circle.collision_response_type() == "Circle");
            ASSERT(circle.collision_type() == "Circle");
            ASSERT(circle.to_collision().position().x() == circle_pos.x());
            ASSERT(circle.to_collision().position().y() == circle_pos.y());
            ASSERT(circle.to_collision().radius() == circle.radius());
        }
    }
    {   // LineSegment Tests
        GVector ls_p1(10, 5);
        GVector ls_p2(30, 25);
        Primitives::LineSegment ls(ls_p1, ls_p2);
        { // Linesegment start/end x/y Tests
            ASSERT(ls.sx() == ls_p1.x());
            ASSERT(ls.sy() == ls_p1.y());
            ASSERT(ls.ex() == ls_p2.x());
            ASSERT(ls.ey() == ls_p2.y());
        }
        { // Linesegment p1, p2
            ASSERT(ls.p1().x() == ls_p1.x());
            ASSERT(ls.p1().y() == ls_p1.y());
            ASSERT(ls.p2().x() == ls_p2.x());
            ASSERT(ls.p2().y() == ls_p2.y());
        }
        { // Collision Type Tests
            ASSERT(ls.collision_response_type() == "LineSegment");
            ASSERT(ls.collision_type() == "LineSegment");
            ASSERT(ls.to_collision().p1().x() == ls_p1.x());
            ASSERT(ls.to_collision().p1().y() == ls_p1.y());
            ASSERT(ls.to_collision().p2().x() == ls_p2.x());
            ASSERT(ls.to_collision().p2().y() == ls_p2.y());
        }

    }
    {   // Rectangle Tests
        GVector r_p1(0, 1);
        GVector r_p2(0, 9);
        GVector r_p3(8, 9);
        GVector r_p4(8, 1);
        Primitives::Rectangle r(r_p1, r_p2, r_p3, r_p4);
        { // Rectangle p1, p2 p3 p4
            ASSERT(r.p1().x() == r_p1.x());
            ASSERT(r.p1().y() == r_p1.y());
            ASSERT(r.p2().x() == r_p2.x());
            ASSERT(r.p2().y() == r_p2.y());
            ASSERT(r.p3().x() == r_p3.x());
            ASSERT(r.p3().y() == r_p3.y());
            ASSERT(r.p4().x() == r_p4.x());
            ASSERT(r.p4().y() == r_p4.y());
        }
        { // Collision Type Tests
            ASSERT(r.collision_response_type() == "Rectangle");
            ASSERT(r.collision_type() == "Rectangle");
            ASSERT(r.to_collision().p1().x() == r_p1.x());
            ASSERT(r.to_collision().p1().y() == r_p1.y());
        }
        { // Left Right Bottom Top Axis aligned tests
            ASSERT(r.left() == 0);
            ASSERT(r.right() == 8);
            ASSERT(r.bottom() == 1);
            ASSERT(r.top() == 9);
        }

    }
    {   // Triangle Tests
        GVector t_p1(0, 0);
        GVector t_p2(0, 9);
        GVector t_p3(8, 9);
        Primitives::Triangle t(t_p1, t_p2, t_p3);
        { // Triangle p1, p2
            ASSERT(t.p1().x() == t_p1.x());
            ASSERT(t.p1().y() == t_p1.y());
            ASSERT(t.p2().x() == t_p2.x());
            ASSERT(t.p2().y() == t_p2.y());
            ASSERT(t.p3().x() == t_p3.x());
            ASSERT(t.p3().y() == t_p3.y());
        }
        { // Collision Type Tests
            ASSERT(t.collision_response_type() == "Triangle");
            ASSERT(t.collision_type() == "Triangle");
            ASSERT(t.to_collision().p1().x() == t_p1.x());
            ASSERT(t.to_collision().p1().y() == t_p1.y());
        }

    }





    cout << "Hello world!" << endl;
    return 0;
}
