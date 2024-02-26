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
            # Arithmetic Instructions
            case 'add':
                p1, p2, p3 = parameters.split(',')
                
                p1 = decimalToBinary(p1[1:], 2) # Remove the '&' or '$' from the register address
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000001{p1}{p2}{p3}\n'
            
            case 'sub':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000010{p1}{p2}{p3}\n'

            # Logic Instructions
            case 'not':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'000011{p1}{p2}0000\n'

            case 'and':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000100{p1}{p2}{p3}\n'

            case 'or':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000101{p1}{p2}{p3}\n'

            case 'xor':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000110{p1}{p2}{p3}\n'

            case 'nand':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'000111{p1}{p2}{p3}\n'

            case 'nor':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'001000{p1}{p2}{p3}\n'

            case 'nxor':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'001001{p1}{p2}{p3}\n'

            # Shift instructions
            case 'sll':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3, 4)

                compiledText += f'001010{p1}{p2}{p3}\n'

            case 'srl':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3, 4)

                compiledText += f'001011{p1}{p2}{p3}\n'

            case 'sra':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3, 4)

                compiledText += f'001100{p1}{p2}{p3}\n'

            case 'tasm':
                parameters = decimalToBinary(parameters[1:], 4)

                compiledText += f'00110100{parameters}0000\n'

            case 'tssm':
                parameters = decimalToBinary(parameters[1:], 4)

                compiledText += f'00111000{parameters}0000\n'

            case 'mtl':
                parameters = decimalToBinary(parameters[1:], 2)

                compiledText += f'001111{parameters}00000000\n'

            case 'mfl':
                parameters = decimalToBinary(parameters[1:], 2)

                compiledText += f'010000{parameters}00000000\n'

            case 'mth':
                parameters = decimalToBinary(parameters[1:], 2)

                compiledText += f'010001{parameters}00000000\n'

            case 'mfh':
                parameters = decimalToBinary(parameters[1:], 2)

                compiledText += f'010010{parameters}00000000\n'

            case 'mtac':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'010011{p1}{p2}0000\n'

            case 'mfac':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'010100{p1}{p2}0000\n'

            case 'slt':
                p1, p2, p3 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)
                p3 = decimalToBinary(p3[1:], 4)

                compiledText += f'010101{p1}{p2}{p3}\n'
            
            # Immediate instructions
            case 'lsi':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2, 8)

                compiledText += f'100000{p1}{p2}\n'

            # Memory access instructions
            case 'swr':
                p1, p2 = parameters.split(',')

                p1 = decimalToBinary(p1[1:], 2)
                p2 = decimalToBinary(p2[1:], 4)

                compiledText += f'100010{p1}{p2}0000\n'

            # Control instructions

    # Write the compiled text to the output file
    with open(outputFile, 'w') as file:
        file.write(compiledText)

# Main function
def main():
    fileNameIn = input('Enter file name: ')
    fileNameOut = input('Enter output file name: ')

    compiler(fileNameIn, fileNameOut)

    print('Done!')

# Run the main function
if __name__ == '__main__':
    main()
