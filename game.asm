#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Like Wang, 1006743062, wanglike, like.wang@mail.utoronto.ca #
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 512 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 (choose the one the applies)
# All done!
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Time score: a clock on the bottom right corner will track players’ playing time.
# P.S. it will show the best record of the player after player win. (the shorter, the better)
# 2. Fail condition: hit on the ground or contact with bats or snakes.
# 3. Win condition: after the King find and get the key lost in the Jungle.
# 4. Moving objects: There are bats that fly around the screen.
# 5. Double jump: allow the player to jump when in mid-air, but only once!
# 6. Pick_up: If a player picks up a mushroom, his/hers total time will be cut by 5 seconds.
# 7. Different levels: there are in total of 3 levels for this game. Try to break the record!
#
# Link to video demonstration for final submission:
# https://www.bilibili.com/video/BV13S4y127p9?spm_id_from=333.999.0.0
#
# Are you OK with us sharing the video with people outside course staff?
# - yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - Time taken	: 7 days
# - Control	: press "d" to move right.
#  		: press "a" to move left.
#  		: press "space" to jump.
# - Background of the game
# 	The background of the game is about the_lost_King (main_character). He used to rule a kingdom.
# 	One day, there were enemies from far away attack his kingdom and occupied his castle.
# 	The exiled King lost in a jungle, he is eager to find the golden key to open the door 
# 	of the_lost_treasure that contain a invincible_sword that only exist in legends.
# 	Run! little King, Run! Find the unknown sword and fight back for your kingdom!
# 	P.S. This is only the chapter 1 of the game < RUN >, the only mission is to find the golden key.
# 	Please let me know if you like this game. I may continue to write it.
# That all! Enjoy the game.
# #####################################################################

# define CONSTANTS
# width = 64, height = 64
.eqv	DISPLAY_FIRST_ADDRESS	0x10008000
.eqv	DISPLAY_LAST_ADDRESS	0x10003FFF					# update this given the values below shift +(64*62)*4
.eqv	DISPLAY_MIDLFT_ADDRESS	0x10009C10					# mid left spot for the king (but jump 2 aligned) +(64*28+4)*4
.eqv	DISPLAY_GROUND_ADDRESS	0x1000BDE8
.eqv	DISPLAY_TIME		0x1000B8D8					# bottom right corner +(64*57-10)*4
.eqv	DISPLAY_LEVEL		0x10008218					# top right corner +(64*2+6)*4
.eqv	DISPLAY_L		0x10008208					# top right corner +(64*2+2)*4
.eqv	DISPLAY_DEAD		0x10009C54					# top right corner +(64*28+21)*4
.eqv	DISPLAY_REC		0x1000A640					# top right corner +(64*38+16)*4
.eqv	DISPLAY_NUM		0x1000AE7C					# top right corner +(64*46+31)*4
.eqv	DISPLAY_S		0x1000AE90					# top right corner +(64*46+36)*4
.eqv	DISPLAY_SPLASH		0x10009C44					# top right corner +(64*28+17)*4
# last address shifts
.eqv 	SHIFT_NEXT_ROW		256						# next row shift = width*4 = 128
# number of pixels
.eqv 	SIZE			4095						# number of pixels - 1 so can use index
.eqv	PLF_WIDTH		24						# width of platform (6*4)
.eqv	HEIGHT			63						# height of pixels - 1 so can use index
.eqv	PLF_HEIGHT		1						# height of platform
# colour
.eqv	COLOUR_BLACK		0x00000000
.eqv	COLOUR_RED		0x00ff0000
.eqv	COLOUR_YELLOW		0x00ffff00
.eqv	COLOUR_ORANGE		0x00ff8000
.eqv	COLOUR_DARK_BLUE	0x000000a5
.eqv	COLOUR_BLUE		0x000000ff
.eqv	COLOUR_BROWN		0x00472400
.eqv	COLOUR_FLESH		0x00ffcc99
.eqv	COLOUR_GREY		0x00555555
.eqv	COLOUR_THORN		0x00C6C6C6
.eqv	COLOUR_LIGHT_GREEN	0x0091ff85
.eqv	COLOUR_GREEN		0x0000ff00
.eqv	COLOUR_JUNGLE		0x00014700
.eqv	COLOUR_WHITE		0x00ffffff
.eqv	COLOUR_PLATFORM		0x00A35C00
.eqv	COLOUR_DARK_PURPLE	0x00460076
.eqv	COLOUR_PURPLE		0x00BF55BF
# objects information
.eqv	MAX_H			6						# the max height the_king can jump

.eqv	NUM_PLFS		6						# number of platforms in level 1/2/3
.eqv	NUM_S			1						# number of snakes in level 1
.eqv	NUM_B			1						# number of bats in level 1
.eqv	NUM_S2			2						# number of snakes in level 2/3
.eqv	NUM_B2			2						# number of bats in level 2/3

.eqv	NUM_M			1						# number of mushrooms
.eqv	NUM_T			15						# number of thorns
.eqv	NUM_P			1						# number of portals / keys
.eqv	NUM_C			1						# number of clocks
.eqv	K_W			6						# width of the King
.eqv	K_H			8						# height of the King
.eqv	L_W			6						# width of the Level
.eqv	L_H			1						# height of the Level
.eqv	M_W			3						# width of the Mushroom
.eqv	M_H			3						# height of the Mushroom
.eqv	S_W			3						# width of the Snake
.eqv	S_H			7						# height of the Snake
.eqv	B_W			9						# width of the Bat
.eqv	B_H			5						# height of the Bat
.eqv	P_W			5						# width of the Portal
.eqv	P_H			5						# height of the Portal
.eqv	C_W			5						# width of the Clock
.eqv	C_H			5						# height of the Clock

.data
# variables
King_rows: 	.word	40
King_columns:	.word	4
King_address:	.word	0
King_is_stand:	.word	1
King_is_coll:	.word	0
King_num_jump:	.word	2

Thorn_rows:	.word	62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62, 62
Thorn_columns:	.word	2, 6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58

	#------------Level_1------------
Level_rows:	.word	48, 47, 26, 56, 22, 33
Level_columns:	.word	2, 36, 18, 20, 40, 33

Mushrm_rows:	.word	23	#53 for testing; 23 for game
Mushrm_columns:	.word	20
is_mushrm:	.word	1

Snake_rows:	.word	40
Snake_columns:	.word	39
Snake_num1:	.word	1
Snake_num2:	.word	2

Bat_rows:	.word	8
Bat_columns:	.word	20
Bat_num1:	.word	1
Bat_num2:	.word	2

Portal_rows:	.word	5
Portal_columns:	.word	55
	#-------------------------------

	#------------Level_2------------
Level_rows2:	.word	48, 37, 37, 36, 47, 24
Level_columns2:	.word	6, 6, 16, 51, 44, 41

Snake_rows2:	.word	31, 29
Snake_columns2:	.word	10, 46

Bat_rows2:	.word	20
Bat_columns2:	.word	20

Portal_rows2:	.word	14
Portal_columns2:.word	55
	#-------------------------------

	#------------Level_3------------
Level_rows3:	.word	48, 47, 26, 56, 22, 33
Level_columns3:	.word	2, 38, 18, 20, 40, 33

Snake_rows3:	.word	40, 49
Snake_columns3:	.word	40, 17

Bat_rows3:	.word	8, 32
Bat_columns3:	.word	20, 52

Key_rows:	.word	5
Key_columns:	.word	10
	#-------------------------------

Clock_rows:	.word	56
Clock_columns:	.word	58
Record:		.word	1000000
Clock_count:	.word	0
Clock_wait:	.word	9

.text 
.globl main

# RUN

main:	
	# ------clear the screen-------
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear
	
	# ------show the openning------
	# 1.show "R" in white
	# wait for 300 milliseconds
	# 2.add "U", show "RU" in white
	# wait for 300 milliseconds
	# 3.add "N", show "RUN" in white
	jal	draw_openning
	# wait for 1000 milliseconds
	li	$v0, 32
	li	$a0, 2000
	syscall
	# 4.show "RUN" in fading into the background
	li	$a1, 0x00E9FFE7
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, 0x00BDFFB6
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, COLOUR_LIGHT_GREEN
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall
	
	li	$a1, 0x0063FF51
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, 0x002EFF00
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, COLOUR_GREEN
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, 0x0000D300
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, 0x0000A400
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, 0x00007500
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall

	li	$a1, COLOUR_JUNGLE
	jal	draw_end_openning
	# wait for 100 milliseconds
	li	$v0, 32
	li	$a0, 200
	syscall
	# -----end of the openning-----
main_start:
	#j	main_start2
	#j	main_start3
	# reset time clock
	li	$t7, 0
	sw	$t7, Clock_count
	# reset existance of mushroom
	li	$t7, 1
	sw	$t7, is_mushrm
	# ------clear the screen-------
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear			# jump to clear and save position to $ra
	# ----initialize registers-----
	# variables
	# $s0: object_rows
	# $s1: object_columns
	# $s2: 1 if collision happened, 0 if not
	# $s3: increment number
	# $s4: number of this object
	# $s5: height left to be risen
	# $s6: time increment
	# $s7: wait time
	li	$s0, 40			# load the value stored in King_rows
	sw	$s0, King_rows
	li	$s1, 4			# load the value stored in King_columns
	sw	$s1, King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
main_loop:
	lw	$a0, King_address	# take out the previous address from data
	li	$a1, K_H		# load the value stored in King_height
	li	$a2, K_W		# load the value stored in King_width
	jal	clear

	li	$a0, 0xffff0000
	lw	$t9, 0($a0)
	bne	$t9, 1, main_update
	jal	keypress

	# Update obstacle location.
main_update:
	# show the current level of the game
	li	$a0, DISPLAY_L
	li	$a1, COLOUR_WHITE
	jal	draw_L
	li	$a0, DISPLAY_LEVEL
	li	$a1, COLOUR_WHITE
	li	$a2, 1
	li	$a3, COLOUR_JUNGLE
	jal	draw_number

	# decrese Clock_wait by 1 each time
	lw	$s7, Clock_wait
	beq	$s7, 0, increse_clock
	addi	$s7, $s7, -1
	sw	$s7, Clock_wait
	j	update_wait_done

increse_clock:
	# increment clock
	lw	$s6, Clock_count
	addi	$s6, $s6, 1
	sw	$s6, Clock_count
	# update time
	li	$a0, DISPLAY_TIME
	li	$a1, COLOUR_WHITE
	move	$a2, $s6
	li	$a3, COLOUR_JUNGLE
	jal	draw_number
	li	$s7, 9
	sw	$s7, Clock_wait
update_wait_done:

	# jump to keypress and save position to $ra
	lw	$s0, King_rows		# load the value stored in King_rows
	lw	$s1, King_columns	# load the value stored in King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
	
	jal	draw_king

	# check if fall on the ground
	bge	$a0, DISPLAY_GROUND_ADDRESS, fail	# if (King_address > ground_address) then game over

	# check if collide on a snake
	la 	$a0, Snake_rows
	la 	$a1, Snake_columns
	li 	$a2, S_W
	li 	$a3, S_H
	li	$t3, NUM_S
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a bat
	la 	$a0, Bat_rows
	la 	$a1, Bat_columns
	li 	$a2, B_W
	li 	$a3, B_H
	li	$t3, NUM_B
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a portal
	la 	$a0, Portal_rows
	la 	$a1, Portal_columns
	li 	$a2, P_W
	li 	$a3, P_H
	li	$t3, NUM_P
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, main_start2	# if (King_win == 1) then level_2

	# draw mushrooms
	lw	$s6, is_mushrm
	beq	$s6, 1, draw_Mushroom
	j	bouns_over
draw_Mushroom:
	la	$s0, Mushrm_rows	# load the value stored in Mushrm_rows[0]
	la	$s1, Mushrm_columns	# load the value stored in Mushrm_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_M		# maxium number of Mushrooms
draw_M_loop:
	bge	$s3, $s4, draw_M_done
	lw 	$s6, 0($s0) 		# load valve of Mushrm_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Mushrm_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Mushrm_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Mushrm_columns[]

	jal 	draw_mushroom
	# check if collide on a mushroom
	la 	$a0, Mushrm_rows
	la 	$a1, Mushrm_columns
	li 	$a2, M_W
	li 	$a3, M_H
	li	$t3, NUM_M
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, bouns		# if (King_win == 1) then clock_count = clock_count - 5
	j	bouns_over

	j	draw_M_loop
draw_M_done:

bouns:
	li	$s6, 0
	sw	$s6, is_mushrm
	lw	$s6, Clock_count
	addi	$s6, $s6, -5
	sw	$s6, Clock_count
	lw	$a0, King_address
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	jal	draw_bouns
	li	$v0, 32
	li	$a0, 1000
	syscall
	# clear the screen to clear the mushroom and prevent time mass
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear
bouns_over:

	# draw levels
	la	$s0, Level_rows		# load the value stored in Level_rows[0]
	la	$s1, Level_columns	# load the value stored in Level_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_PLFS		# maxium number of levels
draw_level_loop:
	bge	$s3, $s4, draw_level_done
	lw 	$s6, 0($s0) 		# load valve of Level_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Level_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Level_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Level_columns[]

	jal 	draw_level
	j	draw_level_loop
draw_level_done:

	# draw thorns
	la	$s0, Thorn_rows		# load the value stored in Thorns_rows[0]
	la	$s1, Thorn_columns	# load the value stored in Thorns_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_T		# maxium number of Thorns
draw_thorns_loop:
	bge	$s3, $s4, draw_thorns_done
	lw 	$s6, 0($s0) 		# load valve of Thorns_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Thorns_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_thorn
	j	draw_thorns_loop
draw_thorns_done:

	# draw clock
	la	$s0, Clock_rows		# load the value stored in Clock_rows[0]
	la	$s1, Clock_columns	# load the value stored in Clock_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_C		# maxium number of Clocks
draw_clock_loop:
	bge	$s3, $s4, draw_clock_done
	lw 	$s6, 0($s0) 		# load valve of Clock_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Clock_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Clock_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Clock_columns[]

	jal 	draw_clock
	j	draw_clock_loop
draw_clock_done:

	# draw portals
	la	$s0, Portal_rows	# load the value stored in Portal_rows[0]
	la	$s1, Portal_columns	# load the value stored in Portal_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_P		# maxium number of Portals
draw_portals_loop:
	bge	$s3, $s4, draw_portals_done
	lw 	$s6, 0($s0) 		# load valve of Portal_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Portal_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_portal
	j	draw_portals_loop
draw_portals_done:

	# draw snakes
	la	$s0, Snake_rows		# load the value stored in Snake_rows[0]
	la	$s1, Snake_columns	# load the value stored in Snake_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_S		# maxium number of snakes
draw_S_loop:
	bge	$s3, $s4, draw_S_done
	lw 	$s6, 0($s0) 		# load valve of Snake_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Snake_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Snake_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Snake_columns[]

	jal 	draw_snake
	j	draw_S_loop
draw_S_done:

	# draw bats
	la	$s0, Bat_rows		# load the value stored in Bat_rows[0]
	la	$s1, Bat_columns	# load the value stored in Bat_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_B		# maxium number of bats
draw_B_loop:
	bge	$s3, $s4, draw_B_done
	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	li	$a1, B_H		# load the value stored in Bat_height
	li	$a2, B_W		# load the value stored in Bat_width
	jal	clear

	addi	$s7, $s7, 54
	li $s6, 55
	div $s7, $s6
	mfhi $s7
	#andi	$s7, $s7, 54		# update the address of the Bat
	sw	$s7, 0($s1) 		# store the updated valve back to Bat_columns[i]

	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	add	$a0, $s2, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	jal 	draw_bat

	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Bat_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Bat_columns[]

	j	draw_B_loop
draw_B_done:

	bne  	$s5, 0, rise
	j	rise_done
rise:
	lw	$s0, King_rows		#load the value stored in 
	ble	$s0, 0, fall_pre	# upper bounder of the screen
	addi	$s0, $s0, -2
	addi	$s5, $s5, -1
	sw	$s0, King_rows
rise_done:

	la	$s0, Level_rows		# load the value stored in Level_rows[0]
	la	$s1, Level_columns	# load the value stored in Level_columns[0]
	jal	check_stand
	lw	$s2, King_is_stand	# load the value stored in King_is_stand
	beq	$s2, 0, fall
	j	main_sleep

fall_pre:
	li	$s5, 0
	j	fall

fall:
	lw	$s0, King_rows
	addi	$s0, $s0, 1
	sw	$s0, King_rows
	
main_sleep:
	li	$v0, 32
	li	$a0, 100
	syscall 

	j main_loop
#----------------------------------------------------------------------------------------------------------------------
main_start2:
	# ------clear the screen-------
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear			# jump to clear and save position to $ra

	li	$s0, 0
	sw	$s0, King_is_coll

	li	$s0, 40			# load the value stored in King_rows
	sw	$s0, King_rows
	li	$s1, 4			# load the value stored in King_columns
	sw	$s1, King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
main_loop2:
	lw	$a0, King_address	# take out the previous address from data
	li	$a1, K_H		# load the value stored in King_height
	li	$a2, K_W		# load the value stored in King_width
	jal	clear

	li	$a0, 0xffff0000
	lw	$t9, 0($a0)
	bne	$t9, 1, main_update2
	jal	keypress

	# Update obstacle location.
main_update2:
	# show the current level of the game
	li	$a0, DISPLAY_L
	li	$a1, COLOUR_WHITE
	jal	draw_L
	li	$a0, DISPLAY_LEVEL
	li	$a1, COLOUR_WHITE
	li	$a2, 2
	li	$a3, COLOUR_JUNGLE
	jal	draw_number

	# decrese Clock_wait by 1 each time
	lw	$s7, Clock_wait
	beq	$s7, 0, increse_clock2
	addi	$s7, $s7, -1
	sw	$s7, Clock_wait
	j	update_wait_done2

increse_clock2:
	# increment clock
	lw	$s6, Clock_count
	addi	$s6, $s6, 1
	sw	$s6, Clock_count
	# update time
	li	$a0, DISPLAY_TIME
	li	$a1, COLOUR_WHITE
	move	$a2, $s6
	li	$a3, COLOUR_JUNGLE
	jal	draw_number
	li	$s7, 9
	sw	$s7, Clock_wait
update_wait_done2:

	# jump to keypress and save position to $ra
	lw	$s0, King_rows		# load the value stored in King_rows
	lw	$s1, King_columns	# load the value stored in King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
	
	jal	draw_king

	# check if fall on the ground
	bge	$a0, DISPLAY_GROUND_ADDRESS, fail	# if (King_address > ground_address) then game over

	# check if collide on a snake
	la 	$a0, Snake_rows2
	la 	$a1, Snake_columns2
	li 	$a2, S_W
	li 	$a3, S_H
	li	$t3, NUM_S2
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a bat
	la 	$a0, Bat_rows2
	la 	$a1, Bat_columns2
	li 	$a2, B_W
	li 	$a3, B_H
	li	$t3, NUM_B
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a portal
	la 	$a0, Portal_rows2
	la 	$a1, Portal_columns2
	li 	$a2, P_W
	li 	$a3, P_H
	li	$t3, NUM_P
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, main_start3		# if (King_win == 1) then level_3

	# draw levels
	la	$s0, Level_rows2		# load the value stored in Level_rows[0]
	la	$s1, Level_columns2	# load the value stored in Level_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_PLFS		# maxium number of levels
draw_level_loop2:
	bge	$s3, $s4, draw_level_done2
	lw 	$s6, 0($s0) 		# load valve of Level_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Level_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Level_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Level_columns[]

	jal 	draw_level
	j	draw_level_loop2
draw_level_done2:

	# draw thorns
	la	$s0, Thorn_rows		# load the value stored in Thorns_rows[0]
	la	$s1, Thorn_columns	# load the value stored in Thorns_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_T		# maxium number of Thorns
draw_thorns_loop2:
	bge	$s3, $s4, draw_thorns_done2
	lw 	$s6, 0($s0) 		# load valve of Thorns_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Thorns_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_thorn
	j	draw_thorns_loop2
draw_thorns_done2:

	# draw clock
	la	$s0, Clock_rows		# load the value stored in Clock_rows[0]
	la	$s1, Clock_columns	# load the value stored in Clock_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_C		# maxium number of Clocks
draw_clock_loop2:
	bge	$s3, $s4, draw_clock_done2
	lw 	$s6, 0($s0) 		# load valve of Clock_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Clock_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Clock_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Clock_columns[]

	jal 	draw_clock
	j	draw_clock_loop2
draw_clock_done2:

	# draw portals
	la	$s0, Portal_rows2	# load the value stored in Portal_rows[0]
	la	$s1, Portal_columns2	# load the value stored in Portal_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_P		# maxium number of Portals
draw_portals_loop2:
	bge	$s3, $s4, draw_portals_done2
	lw 	$s6, 0($s0) 		# load valve of Portal_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Portal_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_portal
	j	draw_portals_loop2
draw_portals_done2:

	# draw snakes
	la	$s0, Snake_rows2		# load the value stored in Snake_rows[0]
	la	$s1, Snake_columns2	# load the value stored in Snake_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_S2		# maxium number of snakes
draw_S_loop2:
	bge	$s3, $s4, draw_S_done2
	lw 	$s6, 0($s0) 		# load valve of Snake_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Snake_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Snake_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Snake_columns[]

	jal 	draw_snake
	j	draw_S_loop2
draw_S_done2:

	# draw bats
	la	$s0, Bat_rows2		# load the value stored in Bat_rows[0]
	la	$s1, Bat_columns2	# load the value stored in Bat_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_B		# maxium number of bats
draw_B_loop2:
	bge	$s3, $s4, draw_B_done2
	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	li	$a1, B_H		# load the value stored in Bat_height
	li	$a2, B_W		# load the value stored in Bat_width
	jal	clear

	addi	$s7, $s7, 54
	li $s6, 55
	div $s7, $s6
	mfhi $s7
	#andi	$s7, $s7, 54		# update the address of the Bat
	sw	$s7, 0($s1) 		# store the updated valve back to Bat_columns[i]

	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	add	$a0, $s2, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	jal 	draw_bat

	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Bat_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Bat_columns[]

	j	draw_B_loop2
draw_B_done2:

	bne  	$s5, 0, rise2
	j	rise_done2
rise2:
	lw	$s0, King_rows		#load the value stored in 
	ble	$s0, 0, fall_pre2	# upper bounder of the screen
	addi	$s0, $s0, -2
	addi	$s5, $s5, -1
	sw	$s0, King_rows
rise_done2:

	la	$s0, Level_rows2		# load the value stored in Level_rows[0]
	la	$s1, Level_columns2	# load the value stored in Level_columns[0]
	jal	check_stand
	lw	$s2, King_is_stand	# load the value stored in King_is_stand
	beq	$s2, 0, fall2
	j	main_sleep2

fall_pre2:
	li	$s5, 0
	j	fall2

fall2:
	lw	$s0, King_rows
	addi	$s0, $s0, 1
	sw	$s0, King_rows
	
main_sleep2:
	li	$v0, 32
	li	$a0, 100
	syscall 

	j main_loop2
#----------------------------------------------------------------------------------------------------------------------
main_start3:
	# ------clear the screen-------
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear			# jump to clear and save position to $ra

	li	$s0, 0
	sw	$s0, King_is_coll

	li	$s0, 40			# load the value stored in King_rows
	sw	$s0, King_rows
	li	$s1, 4			# load the value stored in King_columns
	sw	$s1, King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
main_loop3:
	lw	$a0, King_address	# take out the previous address from data
	li	$a1, K_H		# load the value stored in King_height
	li	$a2, K_W		# load the value stored in King_width
	jal	clear

	li	$a0, 0xffff0000
	lw	$t9, 0($a0)
	bne	$t9, 1, main_update3
	jal	keypress

	# Update obstacle location.
main_update3:
	# show the current level of the game
	li	$a0, DISPLAY_L
	li	$a1, COLOUR_WHITE
	jal	draw_L
	li	$a0, DISPLAY_LEVEL
	li	$a1, COLOUR_WHITE
	li	$a2, 3
	li	$a3, COLOUR_JUNGLE
	jal	draw_number

	# decrese Clock_wait by 1 each time
	lw	$s7, Clock_wait
	beq	$s7, 0, increse_clock3
	addi	$s7, $s7, -1
	sw	$s7, Clock_wait
	j	update_wait_done3

increse_clock3:
	# increment clock
	lw	$s6, Clock_count
	addi	$s6, $s6, 1
	sw	$s6, Clock_count
	# update time
	li	$a0, DISPLAY_TIME
	li	$a1, COLOUR_WHITE
	move	$a2, $s6
	li	$a3, COLOUR_JUNGLE
	jal	draw_number
	li	$s7, 9
	sw	$s7, Clock_wait
update_wait_done3:

	# jump to keypress and save position to $ra
	lw	$s0, King_rows		# load the value stored in King_rows
	lw	$s1, King_columns	# load the value stored in King_columns
	sll	$s0, $s0, 6		
	add	$s0, $s0, $s1		# stored the address in $gp form in $s2
	sll	$s0, $s0, 2		# address = address * 4
	add	$a0, $s0, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	sw	$a0, King_address	# update King address and store it in the data
	
	jal	draw_king

	# check if fall on the ground
	bge	$a0, DISPLAY_GROUND_ADDRESS, fail	# if (King_address > ground_address) then game over

	# check if collide on a snake
	la 	$a0, Snake_rows3
	la 	$a1, Snake_columns3
	li 	$a2, S_W
	li 	$a3, S_H
	li	$t3, NUM_S2
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a bat
	la 	$a0, Bat_rows3
	la 	$a1, Bat_columns3
	li 	$a2, B_W
	li 	$a3, B_H
	li	$t3, NUM_B2
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, fail		# if (King_is_hurt == 1) then fail

	# check if collide on a key
	la 	$a0, Key_rows
	la 	$a1, Key_columns
	li 	$a2, K_W
	li 	$a3, K_H
	li	$t3, NUM_P
	jal	check_collide

	lw	$s2, King_is_coll
	beq	$s2, 1, win		# if (King_win == 1) then win

	# draw levels
	la	$s0, Level_rows3		# load the value stored in Level_rows[0]
	la	$s1, Level_columns3	# load the value stored in Level_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_PLFS		# maxium number of levels
draw_level_loop3:
	bge	$s3, $s4, draw_level_done3
	lw 	$s6, 0($s0) 		# load valve of Level_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Level_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Level_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Level_columns[]

	jal 	draw_level
	j	draw_level_loop3
draw_level_done3:

	# draw thorns
	la	$s0, Thorn_rows		# load the value stored in Thorns_rows[0]
	la	$s1, Thorn_columns	# load the value stored in Thorns_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_T		# maxium number of Thorns
draw_thorns_loop3:
	bge	$s3, $s4, draw_thorns_done3
	lw 	$s6, 0($s0) 		# load valve of Thorns_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Thorns_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_thorn
	j	draw_thorns_loop3
draw_thorns_done3:

	# draw clock
	la	$s0, Clock_rows		# load the value stored in Clock_rows[0]
	la	$s1, Clock_columns	# load the value stored in Clock_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_C		# maxium number of Clocks
draw_clock_loop3:
	bge	$s3, $s4, draw_clock_done3
	lw 	$s6, 0($s0) 		# load valve of Clock_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Clock_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Clock_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Clock_columns[]

	jal 	draw_clock
	j	draw_clock_loop3
draw_clock_done3:

	# draw keys
	la	$s0, Key_rows	# load the value stored in Portal_rows[0]
	la	$s1, Key_columns	# load the value stored in Portal_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_P		# maxium number of Portals
draw_keys_loop:
	bge	$s3, $s4, draw_keys_done
	lw 	$s6, 0($s0) 		# load valve of Portal_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Portal_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Thorns_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Thorns_columns[]

	jal 	draw_key
	j	draw_keys_loop
draw_keys_done:

	# draw snakes
	la	$s0, Snake_rows3		# load the value stored in Snake_rows[0]
	la	$s1, Snake_columns3	# load the value stored in Snake_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_S2		# maxium number of snakes
draw_S_loop3:
	bge	$s3, $s4, draw_S_done3
	lw 	$s6, 0($s0) 		# load valve of Snake_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Snake_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Snake_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Snake_columns[]

	jal 	draw_snake
	j	draw_S_loop3
draw_S_done3:

	# draw bats
	la	$s0, Bat_rows3		# load the value stored in Bat_rows[0]
	la	$s1, Bat_columns3	# load the value stored in Bat_columns[0]
	li	$s3, 0			# increment number
	li	$s4, NUM_B2		# maxium number of bats
draw_B_loop3:
	bge	$s3, $s4, draw_B_done3
	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	addi	$a0, $s2, DISPLAY_FIRST_ADDRESS
	li	$a1, B_H		# load the value stored in Bat_height
	li	$a2, B_W		# load the value stored in Bat_width
	jal	clear

	addi	$s7, $s7, 54
	li $s6, 55
	div $s7, $s6
	mfhi $s7
	#andi	$s7, $s7, 54		# update the address of the Bat
	sw	$s7, 0($s1) 		# store the updated valve back to Bat_columns[i]

	lw 	$s6, 0($s0) 		# load valve of Bat_rows[i] in $s6
	lw 	$s7, 0($s1) 		# load valve of Bat_columns[i] in $s7
	sll	$s2, $s6, 6
	add	$s2, $s2, $s7		# stored the address in $gp form in $s2
	sll	$s2, $s2, 2		# address = address * 4
	add	$a0, $s2, $zero
	addi	$a0, $a0, DISPLAY_FIRST_ADDRESS
	jal 	draw_bat

	addi	$s3, $s3, 1		# $s3 ++
	addi	$s0, $s0, 4		# keep track of the next address of Bat_rows[]
	addi	$s1, $s1, 4		# keep track of the next address of Bat_columns[]

	j	draw_B_loop3
draw_B_done3:

	bne  	$s5, 0, rise3
	j	rise_done3
rise3:
	lw	$s0, King_rows		#load the value stored in 
	ble	$s0, 0, fall_pre3	# upper bounder of the screen
	addi	$s0, $s0, -2
	addi	$s5, $s5, -1
	sw	$s0, King_rows
rise_done3:

	la	$s0, Level_rows3		# load the value stored in Level_rows[0]
	la	$s1, Level_columns3	# load the value stored in Level_columns[0]
	jal	check_stand
	lw	$s2, King_is_stand	# load the value stored in King_is_stand
	beq	$s2, 0, fall3
	j	main_sleep3

fall_pre3:
	li	$s5, 0
	j	fall3

fall3:
	lw	$s0, King_rows
	addi	$s0, $s0, 1
	sw	$s0, King_rows
	
main_sleep3:
	li	$v0, 32
	li	$a0, 100
	syscall 

	j main_loop3

	# end program
fail:
	#li	$a0, DISPLAY_FIRST_ADDRESS
	#li	$a1, 64
	#li	$a2, 64
	#jal	clear

	li	$s5, 0
	jal	draw_dead
	j	over_loop
win:
	li	$a0, DISPLAY_FIRST_ADDRESS
	li	$a1, 64
	li	$a2, 64
	jal	clear

	li	$s5, 0
	jal	draw_win

	lw	$s6, Clock_count
	lw	$s7, Record
	blt	$s6, $s7, new_record
	jal	draw_record
	li	$a0, DISPLAY_NUM
	li	$a1, COLOUR_WHITE
	move	$a2, $s7
	li	$a3, COLOUR_JUNGLE
	jal	draw_number

	j	over_loop
new_record:
	sw	$s6, Record
	jal	draw_newrecord
	li	$a0, DISPLAY_NUM
	li	$a1, COLOUR_WHITE
	move	$a2, $s6
	li	$a3, COLOUR_JUNGLE
	jal	draw_number
	li	$a0, DISPLAY_S
	jal draw_S

over_loop:
	li	$a0, 0xffff0000
	lw	$t9, 0($a0)
	bne	$t9, 1, over_sleep
	jal	keypress
over_sleep:
	li	$v0, 32
	li	$a0, 40
	syscall

	j over_loop

	li	$v0, 10
	syscall
#####################################################################
#			     Functions				    #
#####################################################################

# Keypress

keypress:
	lw	$t0, 4($a0)
	beq	$t0, 0x20, key_space						# ASCII code of 'space' is 0x20
	beq	$t0, 0x61, key_a						# ASCII code of 'a' is 0x61
	beq	$t0, 0x64, key_d						# ASCII code of 'd' is 0x64
	beq	$t0, 0x70, key_p						# ASCII code of 'p' is 0x70
	jr	$ra
	
	# jump
	key_space:
		lw	$t0, King_is_stand
		lw	$t2, King_num_jump
		beq	$t0, 0, check_jump
	check_jump:
		beq	$t2, 0, keypress_done

		li	$s5, MAX_H
		lw	$t1, King_rows
		ble	$t1, 1, keypress_done	# upper bounder of the screen
		addi	$t1, $t1, -2		# when we jump, we want to jump faster than the falling speed
		addi	$s5, $s5, -1
		sw	$t1, King_rows

		addi	$t2, $t2, -1
		sw	$t2, King_num_jump

		b keypress_done
	
	# go left
	key_a:	
		lw	$t1, King_columns
		ble	$t1, 0, keypress_done	# left bounder of the screen
		addi	$t1, $t1, -1
		sw	$t1, King_columns
		b keypress_done
		
	# go right
	key_d:
		lw	$t1, King_columns
		bge	$t1, 58, keypress_done	# right bounder of the screen
		addi	$t1, $t1, 1
		sw	$t1, King_columns
		b keypress_done
	
	key_p:
		# restart game
		la	$ra, main_start
		b	keypress_done
		
	keypress_done:
		jr	$ra			# jump to ra

# COLLIDE Func
	# define storage
	# $a0: the array of the objects_rows
	# $a1: the array of the objects_columns
	# $a2: the width of the objects
	# $a3: the height of the objects
# check_if the King is standing
check_stand:
	move 	$t0, $s0		# load the value stored in Level_rows[0]
	move	$t1, $s1	# load the value stored in Level_columns[0]
	li	$t2, 0			# increment number
	li	$t3, NUM_PLFS		# maxium number of levels

	lw	$t4, King_rows		# take out the previous address from data (y)
	lw	$t5, King_columns	# take out the previous address from data (x)
check_level_loop:
	bge	$t2, $t3, check_level_done
	lw 	$t6, 0($t0) 		# load valve of Level_rows[i] in $s6 	  (b)
	lw 	$t7, 0($t1) 		# load valve of Level_columns[i] in $s7   (a)
	addi	$t7, $t7, L_W		# (a+c)
	bge	$t5, $t7, fall_case
	addi	$t7, $t7, -L_W
	addi	$t7, $t7, -K_W		# (a-w)
	ble	$t5, $t7, fall_case
	addi	$t6, $t6, -K_H		# (b-h)
	bne	$t6, $t4, fall_case	
stand_case:
	li	$t7, 1
	sw	$t7, King_is_stand
	li	$t7, 2
	sw	$t7, King_num_jump
	j	check_level_done
fall_case:
	sw	$zero, King_is_stand	# load the value stored in King_is_stand
	addi	$t0, $t0, 4		# keep track of the next address of Level_rows[]
	addi	$t1, $t1, 4		# keep track of the next address of Level_columns[]
	addi	$t2, $t2, 1		# $t2 ++
	j	check_level_loop
check_level_done:
	jr	$ra			# jump to $ra

# check if the King is colliding with objects
check_collide:
	move	$t0, $a0		# load the value stored in $a0_rows[0]
	move	$t1, $a1		# load the value stored in $a1_columns[0]
	li	$t2, 0			# increment number

	lw	$t4, King_rows		# take out the previous address from data (y)
	lw	$t5, King_columns	# take out the previous address from data (x)
check_collide_loop:
	bge	$t2, $t3, check_collide_done
	lw 	$t6, 0($t0) 		# load valve of rows[i] in $s6 	  (b)
	lw 	$t7, 0($t1) 		# load valve of columns[i] in $s7 (a)

	add	$t7, $t7, $a2		# (a+c)
	bge	$t5, $t7, safe_case
	sub	$t7, $t7, $a2
	addi	$t7, $t7, -K_W		# (a-w)
	ble	$t5, $t7, safe_case

	addi	$t6, $t6, -K_H		# (b-h)
	ble	$t4, $t6, safe_case
	addi	$t6, $t6, K_H
	add	$t6, $t6, $a3		# (b+d)
	bge	$t4, $t6, safe_case
hurt_case:
	li	$t7, 1
	sw	$t7, King_is_coll
	j	check_collide_done
safe_case:
	sw	$zero, King_is_coll	# load the value stored in King_is_hurt
	addi	$t0, $t0, 4		# keep track of the next address of rows[]
	addi	$t1, $t1, 4		# keep track of the next address of columns[]
	addi	$t2, $t2, 1		# $t2 ++
	j	check_collide_loop
check_collide_done:
	jr	$ra			# jump to $ra

# DRAW Func

# 1. Clear the screen
	# define storage
	# $a0: start address
	# $a1: height of the object
	# $a2: width of the object
	# $t7: COLOUR_JUNGLE
	# $t8: height increment
	# $t9: width increment
clear:
	li	$t7, COLOUR_JUNGLE
	li	$t8, 0

	move	$t0, $a0
	loop_h:
	bge 	$t8, $a1, loop_done			# if the increment is equal to the negative width, go down a row
	li	$t9, 0
	move 	$t1, $a0
	loop_w:
	bge	$t9, $a2, loop_h_out
	sw	$t7, 0($a0)				# clear $a0 colour
	addi	$a0, $a0, 4				# $a0 = $a0 + 4
	addi	$t9, $t9, 1				# $t9 ++
	j	loop_w
	loop_h_out:						
	addi	$t8, $t8, 1				# $t8 ++
	move 	$a0, $t1
	addi 	$a0, $a0, 256
	j	loop_h

	loop_done:
	move	$a0, $t0
	jr	$ra					# jump to $ra

# 2. Draw objects

draw_king:
	li $t1, COLOUR_RED
	li $t2, COLOUR_YELLOW
	li $t3, COLOUR_DARK_BLUE
	li $t4, COLOUR_BLUE
	li $t5, COLOUR_BROWN
	li $t6, COLOUR_FLESH
	li $t7, COLOUR_GREY

	sw $t2, 8($a0)
	sw $t2, 12($a0)
	sw $t2, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 4($a0)
	sw $t2, 8($a0)
	sw $t6, 12($a0)
	sw $t6, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 8($a0)
	sw $t6, 12($a0)
	sw $t6, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t4, 12($a0)
	sw $t3, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t6, 8($a0)
	sw $t4, 12($a0)
	sw $t3, 16($a0)
	sw $t6, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t7, 8($a0)
	sw $t7, 12($a0)
	sw $t7, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t7, 8($a0)
	sw $t7, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t5, 8($a0)
	sw $t5, 16($a0)
	
	jr $ra

draw_mushroom:
	li $t0, COLOUR_RED
	li $t1, COLOUR_FLESH
	
	sw $t0, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	
	jr $ra

draw_snake:
	li $t0, COLOUR_RED
	li $t1, COLOUR_YELLOW
	li $t2, COLOUR_GREEN
	
	sw $t2, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 0($a0)
	sw $t0, 4($a0)
	sw $t2, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t2, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 12($a0)
	sw $t2, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 8($a0)
	sw $t2, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	sw $t2, 8($a0)
	sw $t2, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 8($a0)
	sw $t2, 12($a0)
	sw $t2, 16($a0)
	
	jr $ra
	
draw_bat:
	li $t0, COLOUR_RED
	li $t1, COLOUR_BROWN
	
	sw $t1, 12($a0)
	sw $t1, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t1, 20($a0)
	sw $t1, 28($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t0, 12($a0)
	sw $t1, 16($a0)
	sw $t0, 20($a0)
	sw $t1, 24($a0)
	sw $t1, 28($a0)
	sw $t1, 32($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t1, 20($a0)
	sw $t1, 28($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 16($a0)
	
	jr $ra

draw_thorn:
	li $t1, COLOUR_THORN

	sw $t1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	
	jr $ra

draw_portal:
	li $t0, COLOUR_YELLOW
	li $t1, COLOUR_DARK_PURPLE
	li $t2, COLOUR_PURPLE
	li $t3, COLOUR_ORANGE

	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t3, -8($a0)
	sw $t3, -4($a0)
	sw $t0, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	sw $t0, 16($a0)
	sw $t3, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, -4($a0)
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t2, 8($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t3, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, -8($a0)
	sw $t1, -4($a0)
	sw $t1, 0($a0)
	sw $t2, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t1, 20($a0)
	sw $t0, 24($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, -8($a0)
	sw $t1, -4($a0)
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t3, 20($a0)
	sw $t3, 24($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, -8($a0)
	sw $t1, -4($a0)
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t2, 12($a0)
	sw $t1, 16($a0)
	sw $t1, 20($a0)
	sw $t0, 24($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t3, -4($a0)
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t2, 8($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t0, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t3, -8($a0)
	sw $t0, -4($a0)
	sw $t0, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	sw $t0, 16($a0)
	sw $t3, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t3, 4($a0)
	sw $t3, 8($a0)
	sw $t0, 12($a0)

	jr $ra

draw_key:
	li $t1, COLOUR_YELLOW
	
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, -4($a0)
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	
	jr $ra

draw_level:
	li $t1, COLOUR_PLATFORM

	sw $t1, 0($a0)
	sw $t1, 4($a0)
	sw $t1, 8($a0)
	sw $t1, 12($a0)
	sw $t1, 16($a0)
	sw $t1, 20($a0)

	jr $ra

draw_clock:
	li $t0, COLOUR_WHITE
	li $t1, COLOUR_RED
	li $t2, COLOUR_BLACK
	
	sw $t2, 4($a0)
	sw $t2, 8($a0)
	sw $t2, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 0($a0)
	sw $t0, 4($a0)
	sw $t1, 8($a0)
	sw $t0, 12($a0)
	sw $t2, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 0($a0)
	sw $t0, 4($a0)
	sw $t2, 8($a0)
	sw $t0, 12($a0)
	sw $t2, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 0($a0)
	sw $t0, 4($a0)
	sw $t0, 8($a0)
	sw $t1, 12($a0)
	sw $t2, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t2, 4($a0)
	sw $t2, 8($a0)
	sw $t2, 12($a0)

	jr $ra

draw_bouns:
	li $t0, COLOUR_WHITE

	sw $t0, 12($a0)
	sw $t0, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, 0($a0)
	sw $t0, 4($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw $t0, 8($a0)
	sw $t0, 12($a0)
	sw $t0, 16($a0)

	jr $ra
	
# 3. Draw letters

# Draw letters
# $a0: position
# $a1: colour
draw_R:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	sw	$a1, 16($a0)
	
	jr	$ra

draw_U:
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	
	jr	$ra

draw_N:
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 8($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 8($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 16($a0)
	
	jr	$ra

draw_D:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	
	jr	$ra

draw_L:
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	
	jr	$ra

draw_O:
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	
	jr	$ra

draw_E:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	
	jr	$ra
	
draw_A:
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	
	jr	$ra

draw_C:
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	
	jr	$ra
	
draw_I:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	
	jr	$ra

draw_W:
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	sw	$a1, 24($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	sw	$a1, 24($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 12($a0)
	sw	$a1, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 12($a0)
	sw	$a1, 20($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 8($a0)
	sw	$a1, 12($a0)
	sw	$a1, 16($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 8($a0)
	sw	$a1, 16($a0)
	
	jr	$ra

draw_S:
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 12($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	
	jr	$ra

# 4. Draw Words

draw_openning:
	li	$a1, COLOUR_WHITE
	move 	$t9, $ra

	li	$a0, DISPLAY_SPLASH
	jal	draw_R
	li	$v0, 32
	li	$a0, 600
	syscall
	li	$a0, DISPLAY_SPLASH
	addi	$a0, $a0, 40
	jal	draw_U
	li	$v0, 32
	li	$a0, 600
	syscall
	li	$a0, DISPLAY_SPLASH
	addi	$a0, $a0, 80
	jal	draw_N
	li	$a0, DISPLAY_SPLASH

	jr	$t9

draw_end_openning:
	move 	$t9, $ra

	li	$a0, DISPLAY_SPLASH
	jal	draw_R
	li	$a0, DISPLAY_SPLASH
	addi	$a0, $a0, 40
	jal	draw_U
	li	$a0, DISPLAY_SPLASH
	addi	$a0, $a0, 80
	jal	draw_N
	li	$a0, DISPLAY_SPLASH

	jr	$t9

draw_dead:
	li	$a1, COLOUR_WHITE
	move 	$t9, $ra

	li	$a0, DISPLAY_DEAD
	jal	draw_D
	li	$a0, DISPLAY_DEAD
	addi	$a0, $a0, 20
	jal	draw_E
	li	$a0, DISPLAY_DEAD
	addi	$a0, $a0, 40
	jal	draw_A
	li	$a0, DISPLAY_DEAD
	addi	$a0, $a0, 60
	jal	draw_D
	
	jr	$t9

draw_win:
	li	$a1, COLOUR_WHITE
	move	$t9, $ra

	li	$a0, DISPLAY_DEAD
	jal	draw_W
	li	$a0, DISPLAY_DEAD
	addi	$a0, $a0, 40
	jal	draw_I
	li	$a0, DISPLAY_DEAD
	addi	$a0, $a0, 60
	jal	draw_N

	jr	$t9

draw_record:
	li	$a1, COLOUR_WHITE
	move	$t9, $ra

	li	$a0, DISPLAY_REC
	jal	draw_R
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 24
	jal	draw_E
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 44
	jal	draw_C
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 64
	jal	draw_O
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 84
	jal	draw_R
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 108
	jal	draw_D

	jr	$t9

draw_newrecord:
	li	$a1, COLOUR_RED
	move	$t9, $ra

	li	$a0, DISPLAY_REC
	jal	draw_N
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 24
	jal	draw_E
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 44
	jal	draw_W
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 76
	jal	draw_R
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 96
	jal	draw_E
	li	$a0, DISPLAY_REC
	addi	$a0, $a0, 116
	jal	draw_C

	jr	$t9

# 5. Draw numbers
	# $a0: position
	# $a1: COLOUR_WHITE
	# $a2: number to draw
	# $a3: COLOUR_JUNGLE
	# $t7: temp
	# $t8: tens place we are looking at
	# $t9: current digit to draw 
draw_number:
	li	$t8, 10
	div	$a2, $t8							# $a2 / $t8
	mflo	$a2								# $a2 = floor($a2 / $t8) 
	mfhi	$t9								# $t9 = $a2 mod $t8 

	# if both the division and the remainder are 0 than stop
	bne	$a2, $zero, draw_number_zero
	bne	$t9, $zero, draw_number_zero
	jr	$ra

	draw_number_zero: 
	li	$t7, 0
	bne	$t9, $t7, draw_number_one
	b	draw_zero
	draw_number_one: 
	li	$t7, 1
	bne	$t9, $t7, draw_number_two
	b	draw_one
	draw_number_two: 
	li	$t7, 2
	bne	$t9, $t7, draw_number_three
	b	draw_two
	draw_number_three: 
	li	$t7, 3
	bne	$t9, $t7, draw_number_four
	b	draw_three
	draw_number_four: 
	li	$t7, 4
	bne	$t9, $t7, draw_number_five
	b	draw_four
	draw_number_five: 
	li	$t7, 5
	bne	$t9, $t7, draw_number_six
	b	draw_five
	draw_number_six: 
	li	$t7, 6
	bne	$t9, $t7, draw_number_seven
	b	draw_six
	draw_number_seven: 
	li	$t7, 7
	bne	$t9, $t7, draw_number_eight
	b	draw_seven
	draw_number_eight: 
	li	$t7, 8
	bne	$t9, $t7, draw_number_nine
	b	draw_eight
	draw_number_nine: 
	li	$t7, 9
	bne	$t9, $t7, draw_number_next
	b	draw_nine

	draw_number_next:
	# shift draw number position
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -SHIFT_NEXT_ROW
	addi	$a0, $a0, -16

	b draw_number

# ------------------------------------
draw_zero:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_one:
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_two:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a3, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_three:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_four:
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_five:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a3, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_six:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a3, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_seven:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_eight:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
# ------------------------------------
draw_nine:
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a1, 0($a0)
	sw	$a1, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)
	addi	$a0, $a0, SHIFT_NEXT_ROW
	sw	$a3, 0($a0)
	sw	$a3, 4($a0)
	sw	$a1, 8($a0)

	b	draw_number_next
