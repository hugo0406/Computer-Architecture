#include <stdint.h>
#include <stdio.h>

extern uint64_t get_cycles();
extern uint64_t get_instret();
extern int find_string(uint64_t x, int n);

int main()
{
    int  result[3];
    uint64_t test_data[] = {0x0f00000000000000, 
                            0x0000000000000000, 
                            0x0123456789abcdef};	

    uint64_t instret = get_instret();
    uint64_t start = get_cycles();             

    for (int i = 0; i < 3; i++) {
        uint64_t x = test_data[i];
        int n = 4; 
        result[i] = find_string(x, n);
    }

    uint64_t fin = get_instret();
    uint64_t end = get_cycles();

    uint64_t cyclecount = end - start;
    uint64_t instrcount = fin - instret;

    for (int i = 0; i < 3; i++) { printf("Test Case %d: Input: 0x%016llx, Result: %d\n", i+1, test_data[i], result[i]);}
    
    printf("cycle count: %u\n", (unsigned int) cyclecount);
    printf("instruction count: %u\n", (unsigned) (instrcount));
    return 0;
}
