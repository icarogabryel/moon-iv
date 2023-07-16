def toBits(binary_string, bits_len):
    # string with decimal to string with binary
    integer_value = int(binary_string)
    binary_representation = bin(integer_value)[2:]  # Remove o prefixo "0b"
    
    # Add zeros to the left
    if len(binary_representation) < bits_len:
        num_zeros = bits_len - len(binary_representation)
        binary_representation = ('0' * num_zeros) + binary_representation
    
    # Check if the binary string is bigger than bits_len
    if len(binary_representation) > bits_len:
        raise Exception('Binary string is bigger than bits_len')
    
    return binary_representation

result = ''

with open('input.txt', 'r') as file:
    lines = file.readlines()

for line in lines:
    line = line.split('//')[0]
    line = line.strip()

    if(line[:5] == 'nope'):
        result += '0000000000000000\n'
        continue

    inst, parametres = line.split(' ', 1)
    parametres = parametres.replace(' ', '')

    match(inst):
        # Logical and Arithmetic
        case 'add':
            p1, p2, p3 = parametres.split(',')

            p1 = toBits(p1[1:], 2)
            p2 = toBits(p2[1:], 4)
            p3 = toBits(p3[1:], 4)

            result += f'000001{p1}{p2}{p3}\n'
        
        case 'sub':
            p1, p2, p3 = parametres.split(',')

            p1 = toBits(p1[1:], 2)
            p2 = toBits(p2[1:], 4)
            p3 = toBits(p3[1:], 4)

            result += f'000010{p1}{p2}{p3}\n'

        case 'mfac':
            p1, p2 = parametres.split(',')

            p1 = toBits(p1[1:], 2)
            p2 = toBits(p2[1:], 4)

            result += f'010100{p1}{p2}0000\n'
        
        # Immediate
        case 'lsi':
            p1, p2 = parametres.split(',')

            p1 = toBits(p1[1:], 2)
            p2 = toBits(p2, 8)

            result += f'100000{p1}{p2}\n'

        # Memory access
        case 'swr':
            p1, p2 = parametres.split(',')

            p1 = toBits(p1[1:], 2)
            p2 = toBits(p2[1:], 4)

            result += f'100010{p1}{p2}0000\n'

with open('output.txt', 'w') as file:
    file.write(result)

print('Done!')
