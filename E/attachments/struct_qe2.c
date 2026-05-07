#include <stdio.h>

struct rational {int num, den};

int Euclid(int a, int b){
    if (!(a % b))
        return b;
    else
        Euclid(b, a % b);
}

int getNumerator(struct rational x){
    return x.num;
}

int getDenominator(struct rational x){
    return x.den;
};

struct rational make_rational(int num, int den){
    struct rational x = {num, den};
    return x;
}

int print_rational(struct rational x){
    printf("%d/%d\n", getNumerator(x), getDenominator(x));
}

struct rational add_rational(struct rational x, struct rational y){
    if (getDenominator(x) == getDenominator(y)){
        struct rational z = {getNumerator(x) + getNumerator(y), getDenominator(x)};
        return z;
    }
    else{
        struct rational z = {getNumerator(x)*getDenominator(y) + getNumerator(y)*getDenominator(x), getDenominator(x)*getDenominator(y)};
        int gcd = Euclid(getNumerator(z), getDenominator(z));
        struct rational a = {getNumerator(z)/gcd, getDenominator(z)/gcd};
        return a;
    }
}

struct rational sub_rational(struct rational x, struct rational y)
{
    if (getDenominator(x) == getDenominator(y))
    {
        struct rational z = {getNumerator(x) - getNumerator(y), getDenominator(x)};
        return z;
    }
    else{        
        struct rational z = {getNumerator(x) * getDenominator(y) - getNumerator(y) * getDenominator(x), getDenominator(x) * getDenominator(y)};
        int gcd = Euclid(getNumerator(z), getDenominator(z));
        struct rational a = {getNumerator(z) / gcd, getDenominator(z) / gcd};
        return a;
    }
}

struct rational mul_rational(struct rational x, struct rational y){
        struct rational z = {getNumerator(x)*getNumerator(y), getDenominator(x)*getDenominator(y)};
        int gcd = Euclid(getNumerator(z), getDenominator(z));
        struct rational a = {getNumerator(z) / gcd, getDenominator(z) / gcd};
        return a;
}

struct rational div_rational(struct rational x, struct rational y)
{
    struct rational z = {getNumerator(x) * getDenominator(y), getDenominator(x) * getNumerator(y)};
    int gcd = Euclid(getNumerator(z), getDenominator(z));
    struct rational a = {getNumerator(z) / gcd, getDenominator(z) / gcd};
    return a;
}

int main(void)
{
    struct rational a = make_rational(1, 8);  /* a=1/8 */
    struct rational b = make_rational(-1, 8); /* b=-1/8 */
    print_rational(add_rational(a, b));
    print_rational(sub_rational(a, b));
    print_rational(mul_rational(a, b));
    print_rational(div_rational(a, b));

    return 0;
}