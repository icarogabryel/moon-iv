from translator import toMachineCode

def main():
    input_file = "../test/la_ops.txt"
    output_file = "../src/program_code.txt"

    with open(input_file, 'r') as f:
        lines = f.readlines()

    machineCode = toMachineCode(lines)

    with open(output_file, 'w') as f:
            f.write(machineCode + '\n')

if __name__ == "__main__":
    main()
