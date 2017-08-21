# 用系统功能调用从键盘输入，转换后在屏幕上显示，具体要求如下： 
# (1) 如果输入的是字母（A~Z，区分大小写）或数字（0~9），则将其转换成对应的英文单词后在屏幕上显示，对应关系见下表 
# (2) 若输入的不是字母或数字，则在屏幕上输出字符“*”， 
# (3) 每输入一个字符，即时转换并在屏幕上显示， 
# (4) 支持反复输入，直到按“?”键结束程序。

.data
upperArr: .asciiz "Alpha", "Bravo", "China", "Delta", "Echo", "Foxtrot", "Golf", 
	"Hotel", "India", "Juliet", "Kilo", "Lima", "Mary", "November",
	"Oscar", "Paper", "Quebec", "Research", "Sierra", "Tango",
	"Uniform", "Victor", "Whisky", "X-ray", "Yankee", "Zulu"
upperArrOffset: .word 0, 6, 12, 18, 24, 29, 37,
	42, 48, 54, 61, 66, 71, 76,
	85, 91, 97, 104, 113, 120,
	126, 134, 141, 148, 154, 161
numArr: .asciiz "zero", "First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth"
numOffset: .word 0, 5, 11, 18, 24, 31, 37, 43, 51, 58

.text
main:
	
	li $v0, 12  # 12 is the code for input a char
	syscall
	move $t0, $v0
	li $t1, 63 # '?'=63  means the end
	beq $t0, $t1, exit
	
	# print a space
	li $v0, 11  # to print char
	li $a0, 32 # ' ' = 32
	syscall
	
uppercase:
	# 'A' <= $v0 <= 'Z'
	li $t2, 65    #t2 = 'A'
	blt $t0, $t2, num  # $t0 is the input char, if t0<'A', jump to number
	li $t2, 90    #t2 = 'Z'
	bgt $t0, $t2, lowercase  # $t0 is the input char, if t0>'Z', jump to lowercase
	
	sub $t1, $t0, 65  # compute offset of index in $t1
	la $t2, upperArrOffset
	mul $t1, $t1, 4
	add $t2, $t2, $t1  #offsets are stored in word(4 bytes)
	lw $t2, ($t2)   # get offset in $t2
	la $a0, upperArr
	add $a0, $a0, $t2
	li $v0, 4  #to print string
	syscall
	b loop
	
lowercase:
	# 'a' <= $v0 <= 'z'
	li $t2, 97    #t2 = 'a'
	blt $t0, $t2, num  # $t0 is the input char, if t0<'a', jump to else
	li $t2, 123    #t2 = 'z'
	bgt $t0, $t2, lowercase  # $t0 is the input char, if t0>'z', jump to else
	
	# print the first char
	li $v0, 11  # to print char
	move $a0, $t0 # $a0 = inputchar
	syscall
	
	#print from the second char
	sub $t1, $t0, 97  # compute offset in $t1
	la $t2, upperArrOffset
	mul $t1, $t1, 4
	add $t2, $t2, $t1  #offsets are stored in word(4 bytes)
	lw $t2, ($t2)
	la $a0, upperArr
	add $a0, $a0, $t2
	add $a0, $a0, 1
	li $v0, 4  #to print string
	syscall
	
	b loop
	
num:
	li $t2, 48    #t2 = '0'
	blt $t0, $t2, else  # $t0 is the input char, if t0<'0', jump to else
	li $t2, 57    #t2 = '9'
	bgt $t0, $t2, else  # $t0 is the input char, if t0>'9', jump to else
	
	sub $t1, $t0, 48  # compute offset in $t1
	la $t2, numOffset
	mul $t1, $t1, 4
	add $t2, $t2, $t1  #offsets are stored in word(4 bytes)
	lw $t2, ($t2)   # get offset in $t2
	la $a0, numArr
	add $a0, $a0, $t2
	li $v0, 4  #to print string
	syscall
	
	b loop

else:
	li $v0, 11  # to print char
	li $a0, 42 # '*' = 42
	syscall
	
loop:
	# next line
	li $v0, 11  # to print char
	li $a0, 10 # '\n' = 10
	syscall
	
	b main	
	
exit:
	#end of program