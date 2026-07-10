#include <stdio.h>
#include <math.h>

enum coordinate_type
{
    RECTANGULAR,
    POLAR
};

struct complex_struct
{
    enum coordinate_type t;
    double a, b;
};

struct complex_struct make_from_real_img(double x, double y)
{
    struct complex_struct z;
    z.t = RECTANGULAR;
    z.a = x;
    z.b = y;
    return z;
}

struct complex_struct make_from_mag_ang(double r, double A)
{
    struct complex_struct z;
    z.t = POLAR;
    z.a = r;
    z.b = A;
    return z;
}

double real_part(struct complex_struct x)
{
    if (x.t == RECTANGULAR) 
        return x.a;
    else 
        return x.a*cos(x.b);
}

double img_part(struct complex_struct x)
{
    if (x.t == RECTANGULAR)
        return x.b;
    else
        return x.a * sin(x.b);
}

double magnitude(struct complex_struct x)
{
    if (x.t == POLAR)
        return x.a;
    else
        return sqrt(x.a * x.a + x.b * x.b);
}

double angle(struct complex_struct x)
{
    if (x.t == POLAR)
        return x.b;
    else
        return atan2(x.b, x.a);
}

