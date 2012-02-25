#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

int main ()
{
        uint8_t ideal_job_n = sysconf ( _SC_NPROCESSORS_ONLN ) + 1;
        printf ( "%d", ideal_job_n );
        return 0;
}
