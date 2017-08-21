# 字符串查找比较
# 利用系统功能调用从键盘输入一个字符串，然后输入单个字符，查找该字符串中是否有该字符（区分大小写）。具体要求如下：
# (1) 如果找到，则在屏幕上显示：
# Success! Location: X
# 其中，X为该字符在字符串中第一次出现的位置
# (2) 如果没找到，则在屏幕上显示：
# Fail!
# (3) 输入一个字符串后，可以反复输入希望查询的字符，直到按“?”键结束程序
# (4) 每个输入字符独占一行，输出查找结果独占一行，位置编码从1开始。
# 提示：为避免歧义，字符串内不包含"?"符号
# 格式示例如下：
# abcdefgh
# a
# Success! Location: 1
# x
# Fail!

# 字符串查找比较
# '?'=63 '\n'=10

.data
buffer: .space 512
successmsg: .asciiz "Success! Location: "
failmsg: .asciiz "Fail!"

# new line
.macro newline
li $v0, 11
li $a0, 10 # '\n'
syscall
.end_macro

.text
main:
	# input string
	li $v0, 8
	la $a0, buffer
	li $a1, 512
	syscall

inputchar:
	# input a char, stored in $v0 
	li $v0, 12
	syscall
	move $t0, $v0  # $t0 records the input char
	li $t1, 63 # '?'=63  means the end
	beq $t0, $t1, exit  # if input=? exit
	newline
	
	
	la $t1, buffer
removeNextLineChar:
	lb $t2, ($t1)
	beqz $t2, endofLine
	add $t1, $t1, 1
	b removeNextLineChar
	
endofLine:
	sub $t1, $t1, 1
	lb $t2, ($t1)
	li $t3, 10
	bne $t2, $t3, initsearch
	sb $0, ($t1)
	
	
initsearch:
	la $t1, buffer  # address of string
	
search:
	lb $t2, ($t1)   #get one char in a string
	beqz $t2, fail
	beq $t0, $t2, found
	add $t1, $t1, 1
	b search
	
found:
	li $v0, 4  #to print string
	la $a0, successmsg
	syscall
	
	la $t3, buffer  #address of string
	sub $t1, $t1, $t3
	add $a0, $t1, 1
	li $v0, 1  #to print a char
	syscall
	
	newline
	b inputchar

fail:
	li $v0, 4  #to print string
	la $a0, failmsg
	syscall
	newline
	b inputchar
	
exit:
	# end of program
