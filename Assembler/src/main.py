from translator import assembledToMachineCode

assembledFile = "Assembler/Test codes/arith and logic ops.asm"
machineCodeFile = "program_code.txt"

with open(assembledFile, 'r') as file:
    assembledTextInLines = file.readlines()

machineCodeText = assembledToMachineCode(assembledTextInLines)

with open(machineCodeFile, 'w') as file:
    file.write(machineCodeText)
