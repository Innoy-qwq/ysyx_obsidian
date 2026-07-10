# include<stdio.h>
# include<stdarg.h>

void printf_int(int num){
    if (num == 0){
        fputc('0', stdout);
        return;
    }

    if (num < 0){
        fputc('-', stdout);
        num = -num;
    }

    char buf[32] = {};
    int i = 0;
    while(num){
        buf[i++] = (char) (num%10 + '0');
        num/=10;
    }

    while(--i >= 0)
        fputc(buf[i], stdout);
}


void printf_double(double num)
{
    if (num < 0)
    {
        fputc('-', stdout);
        num = -num;
    }

    printf_int((int)num);
    fputc('.', stdout);

    for (int i=0; i<6; i++){
        num -= (int)num;
        num *= 10;
        fputc((char) ((int)num + '0'), stdout);
    }
}


void myprintf(const char *format, ...){
    char p;
    va_list ap;
    
    va_start(ap, format);

    while (*format){
        if (*format != '%'){
            fputc(*format++, stdout);
            continue;
        }

        format++;
        switch(*format){
            case 'd':
                printf_int(va_arg(ap, int));
                format++;
                break;
            case 'f':
                printf_double(va_arg(ap, double));
                format++;
                break;
        }
    }

    va_end(ap);
}

int main(void){
    myprintf("wwww%daaaa%faa", 23, -0.14);
}

