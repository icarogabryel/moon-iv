# string with decimal to string with binary
def decimalToBinary(decimalNumber: str, length: int) -> str:
    # string with decimal to string with binary
    integerValue = int(decimalNumber)
    binaryRepresentation = bin(integerValue)[2:]  # Removes the '0b' from the binary string
    
    # Check if the binary string is bigger than bits_len
    if len(binaryRepresentation) > length:
        raise Exception('Binary representation of given number is bigger than bits space available')

    # Add zeros to the left
    if len(binaryRepresentation) < length:
        zerosQuant = length - len(binaryRepresentation)
        binaryRepresentation = ('0' * zerosQuant) + binaryRepresentation
    
    return binaryRepresentation

# Assembly to binary compiler function
def compiler(inputFile: str, outputFile: str):
    compiledText = '' # Resulting binary string

    with open(inputFile, 'r') as file:
        lines = file.readlines()

    for line in lines:
        line = line.split('//')[0] # Remove comments
        line = line.strip()

        if(line[:5] == 'nope'): # Case the instruction is No Operation
            compiledText += '0000000000000000\n'
            continue

        inst, parameters = line.split(' ', 1) # Split the instruction and the parameters
        parameters = parameters.replace(' ', '') # Remove spaces

        match(inst):
            # Logical and Arithmetic Instructions
            case 'add':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000001{p1}{p2}{p3}\n'
            
            case 'sub':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                result += f'000010{p1}{p2}{p3}\n'

            case 'mfac':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'010100{p1}{p2}0000\n'
            
            # Immediate
            case 'lsi':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2, 8)

                compiledText += f'100000{p1}{p2}\n'

            # Memory access
            case 'swr':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'100010{p1}{p2}0000\n'

    return compiledText

def main():
    fileNameIn = input('Enter file name: ')
    fileNameOut = input('Enter output file name: ')

    compiler(fileNameIn, fileNameOut)

    print('Done!')

if __name__ == '__main__':
    main()
