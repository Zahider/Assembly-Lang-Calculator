#Student Name: Zahid Rafiqzad 
#Student ID:   100702916
#Computer Architecture Case Study

.data
	#messages
	options: .asciiz "\nPlease enter a, b, c or d: "
	youEntered: .asciiz "\nYou picked: "
	
	bmiMessage: .asciiz "\nThis is the BMI Calculator!"
	bmiMessage1: .asciiz "\n\nEnter Weight in Kg: "
	bmiMessage2: .asciiz "\n\nEnter Height in Meters: "
	bmiMessage3: .asciiz "Weight is: "
	bmiMessage4: .asciiz "Height is: "
	bmiMessage5: .asciiz "\nYour height squared is: "
	bmiMessage6: .asciiz "\nYour BMI is: "
	
	tempMessage: .asciiz "\nThis converts Farenheit to Celcius!"
	tempMessage1: .asciiz "\n\nEnter a temperature in Fahrenheit: "
	tempMessage2: .asciiz "\nYou entered: "
	tempMessage3: .asciiz "\nYour temperature in Celsius is: "
	
	weightMessage: .asciiz "\nThis converts Pounds to Kilograms!"
	weightMessage1: .asciiz "\n\nEnter weight in Pounds:  "
	weightMessage2: .asciiz "\nYou entered: "
	weightMessage3: .asciiz "\nThe weight in Kg is: "
	
	sumMessage: .asciiz "\nThis is the sum calculator!"
	sumMessage0: .asciiz "\Enter a number to find its Sum: "
	sumMessage1: .asciiz "\nSum is: "
	repeatMessage: .asciiz "\nThat was not a, b, c or d!"

	#variables
	sumInput: .word 0
	sumAns: .word 0
	input: .space	4 #only takes in one character
	bmiWeight: .float 0.0
	bmiHeight: .float 0.0
	tempInput: .float 0.0
	tempCalc: .float 32.0
	tempCalc2: .float 1.8
	pounds: .float 0.0
	subtract: .float 2.2046

.text
.globl main
	#put value of bmiheight/bmiweight into $f4 and $f5
	lwc1 $f1, subtract
	lwc1 $f2, tempCalc2 # =1.8
	lwc1 $f4, bmiWeight # =0
	lwc1 $f6, bmiHeight # =0
	lwc1 $f8, tempCalc  # =32
	lwc1 $f10, pounds
	
main:
#loop restarts if user did not input a,b,c or d
loop:
	#display "options" messsage
	li $v0, 4
	la $a0, options
	syscall

	#user input 
	li $v0, 8
	la $a0, input
	li $a1, 4
	syscall
	
	#display "youEntered" messsage
	li $v0, 4
	la $a0, youEntered
	syscall

	#display option picked
	li $v0, 4
	la $a0, input
	syscall
	
	lb $a0, input

#branch if equal to
beq $a0, 'a',bmi 
beq $a0, 'b',temperature
beq $a0, 'c', scale
beq $a0, 'd', sum

j loop
#tell the program the procedure is done
li $v0,10
syscall

#######################################################
bmi:
li $v0,4
la $a0,bmiMessage
syscall

li $v0,4
la $a0,bmiMessage1
syscall

#gets weight from user
li $v0,6
syscall

#Display weight message
li $v0,4
la $a0,bmiMessage3
syscall

#Display weight
li $v0,2
add.s $f12, $f0, $f4
syscall

mov.s $f8, $f12

#prompt user for height
li $v0,4
la $a0,bmiMessage2
syscall

#gets height from user
li $v0,6
syscall

#Display height message
li $v0,4
la $a0,bmiMessage4
syscall

#Display height
li $v0,2
add.s $f12, $f0, $f6
syscall

mov.s $f10, $f12 #empty the f12 register in case it needs to be reused

#calculate m^2
mul.s $f12, $f10, $f10
mov.s $f6, $f12 #m^2 is now stored in $f6

#Display bmi message
li $v0,4
la $a0,bmiMessage6
syscall

li $v0, 2
div.s $f12, $f8, $f6 # kg/m^2
syscall

j exit
######################################################
temperature:
#prompt user for weight in kg
li $v0,4
la $a0,tempMessage
syscall
li $v0,4
la $a0,tempMessage1
syscall

#gets temperature from user
li $v0,6
syscall

#Display fahrenheit input message
li $v0,4
la $a0,tempMessage2
syscall

#display temp inputted
li $v0, 2
add.s $f12, $f0, $f4
syscall

mov.s $f6, $f12 #user input is in $f8

# calculations for f-32
li $v0, 2
sub.s $f12, $f12, $f8
mov.s $f8, $f12# f-32 stored in $f8

#Display fahrenheit input message
li $v0,4
la $a0,tempMessage3
syscall

li $v0, 2
div.s $f12, $f8, $f2
syscall

j exit
#####################################################
scale: 
#prompt user for weight in kg
li $v0,4
la $a0,weightMessage
syscall
li $v0,4
la $a0,weightMessage1
syscall

#gets temperature from user
li $v0,6
syscall

#Display fahrenheit input message
li $v0,4
la $a0,weightMessage2
syscall

#display temp inputted
li $v0, 2
add.s $f12, $f0, $f10
syscall

mov.s $f6, $f10 #user input is in $f10

#Display fahrenheit input message
li $v0,4
la $a0,weightMessage3
syscall

li $v0, 2
div.s $f12, $f12, $f1
syscall
j exit
#####################################################
sum: 
li $v0, 4
la $a0, sumMessage
#read promtMessage
li $v0, 4
la $a0, sumMessage0
syscall

#take input
li $v0,5
syscall
sw $v0, sumInput#storing input

#call factorial function
lw $a0, sumInput
jal sumCalc#call function
sw $s1, sumAns#returns value from function

#display sum
li $v0, 4
la $a0, sumMessage1
syscall
li $v0, 1
lw $a0, sumAns
syscall

#end main
li $v0, 10

syscall
j exit

exit: 
#tell the program the procedure is done
li $v0,10
syscall

#findFactorial dunction
.globl sumCalc
sumCalc:
	subu $sp, $sp, 8
	sw $ra, ($sp)#storing value of returning address in the stack
	sw $s0, 4($sp)#4b apart from the value stored above in the stack
	
	#base case
	li $s1, 1 #store final results in $s1
	
	#find factorial n-1
	move $s2, $v0 #store $v0 into $s3 which is what function exit returned
	add $s2, $s2, 1 # $v0+1
	mul $s1, $v0, $s2 # $vo + ($v0 + 1)
	div $s1, $s1, 2 # $s2 / 2
			
	jr $ra

