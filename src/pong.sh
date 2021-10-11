#!/bin/bash

##################################################
# 			Pong shell game by ByteBox       	       #      
##################################################

# variables
CHARACTER="."
PADDLE_CHARACTER="#"
BALL_CHARACTER="@"
PADDLE_HEIGHT=10
PADDLE_WIDTH=3
PADDLE_1_HEIGHT=7
PADDLE_2_HEIGHT=7
BALL_X_POS=40
BALL_Y_POS=12
BALL_X_MOV=1
BALL_Y_MOV=0

# clear screen
clear

# input stuff
stty -icanon -echo

# game loop
while :
do
	printf "\033[0;0f"			# ANSI sequence to move cursor to top left corner
	for y in {1..25..1}			# y screen loop
	do
		for x in {1..80..1}		# x screen loop
		do
			# comparisons for which character to put 
			if [ $y -le $(( PADDLE_HEIGHT + PADDLE_1_HEIGHT )) ] && [ $y -gt $PADDLE_1_HEIGHT ] && [ $x -le $PADDLE_WIDTH ]; then
				printf "%c" "$PADDLE_CHARACTER"
			elif [ $y -le $(( PADDLE_HEIGHT + PADDLE_2_HEIGHT )) ] && [ $y -gt $PADDLE_2_HEIGHT ] && [ $x -gt $(( 80 - PADDLE_WIDTH )) ]; then
				printf "%c" "$PADDLE_CHARACTER"
			elif [ $y -eq $BALL_Y_POS ] && [ $x -eq $BALL_X_POS ]; then
				printf "%c" "$BALL_CHARACTER"
			else 
				printf "%c" "$CHARACTER"
			fi
		done
		printf "\n"
	done

	# read one character
	read -n1 -t 0.1;

	# input control stuff
	if [ "$REPLY" = "s" ]; then
		 (( PADDLE_1_HEIGHT += 1 ))
	elif [ "$REPLY" = "w" ]; then
		 (( PADDLE_1_HEIGHT -= 1 ))
	elif [ "$REPLY" = "e" ]; then
		 (( PADDLE_2_HEIGHT -= 1 ))
	elif [ "$REPLY" = "d" ]; then
		 (( PADDLE_2_HEIGHT += 1 ))
	fi

	# update ball direction
	if [ $BALL_X_POS -ge $(( 80 - PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_2_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_2_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=0
	elif [ $BALL_X_POS -ge 80 ]; then 
		break
	fi
	if [ $BALL_X_POS -le $(( 1 + PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_1_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_1_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=1
	elif [ $BALL_X_POS -le 1 ]; then 
		break
	fi
	
	if [ $BALL_Y_POS -ge 25 ]; then 
		BALL_Y_MOV=0
	elif [ $BALL_Y_POS -le 1 ]; then 
		BALL_Y_MOV=1
	fi

	# update ball pos
	if [ $BALL_X_MOV -eq 0 ]; then
		(( BALL_X_POS -= 1 ))
	elif [ $BALL_X_MOV -eq 1 ]; then
		(( BALL_X_POS += 1 ))
	fi
	if [ $BALL_Y_MOV -eq 0 ]; then
		(( BALL_Y_POS -= 1 ))
	elif [ $BALL_Y_MOV -eq 1 ]; then
		(( BALL_Y_POS += 1 ))
	fi
done
printf "Game over!\n" 
##################################################
