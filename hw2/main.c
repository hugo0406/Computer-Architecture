#include <stdint.h>
#include <stdio.h>
extern uint64_t get_cycles();
extern void encrypt(uint64_t *data, uint64_t key);
extern void decrypt(uint64_t *data, uint64_t key);


int main()
{
    uint64_t key = 0x0123456789ABCDEF; // Encryption key
    uint64_t test_data = 0x0000000010101010; // Test data in binary


    printf("Original Data:\n");
    printf("Data: 0x%016lx\n", test_data);

    int32_t start = get_cycles();

    /* Encrypt and print encrypted data */
    printf("\nEncrypted Data:\n");
    encrypt(&test_data, key);
    printf("Data: 0x%016lx\n", test_data);

    /* Decrypt and print decrypted data */
    printf("\nDecrypted Data:\n");
    decrypt(&test_data, key);
    printf("Data: 0x%016lx\n", test_data);
    int32_t end = get_cycles();
    
    return 0;
}
