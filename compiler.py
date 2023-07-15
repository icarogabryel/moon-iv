# example:
# add 1 2 3
# will result in 0000010100100011

def convert_to_fixed_bits(binary_string, num_bits):
    integer_value = int(binary_string)
    binary_representation = bin(integer_value)[2:]  # Remove o prefixo "0b"
    
    if len(binary_representation) < num_bits:
        num_zeros = num_bits - len(binary_representation)
        binary_representation = '0' * num_zeros + binary_representation
    
    return binary_representation

result = ''

with open('input.txt', 'r') as file:
    lines = file.readlines()

for line in lines:
    inst, parametres = line.split(' ', 1)

    match(inst):
        case 'nope':
            result += '0000000000000000\n'
        case 'add':
            p1, p2, p3 = parametres.split(',')
            result += f'000001{p1}{p2}{p3}'

result += '\n'

with open('output.txt', 'w') as file:
    file.write(result)

print('Done!')
