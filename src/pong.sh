#!/bin/bash

##################################################
#          Pong shell game by ByteBox            #     
##################################################

############################################################################################################################################
# variables

BACKGROUND_CHARACTER="."
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


############################################################################################################################################
# functions

# function for filling background with background character
fill_background () {
	printf "\033[0;0f"			# ANSI sequence to move cursor to top left corner
	for y in {1..25..1}			# y screen loop
	do
		for x in {1..80..1}		# x screen loop
		do
			# put background character
			printf "%c" "$BACKGROUND_CHARACTER"
		done
		if  [ $y -lt 25 ]; then
			printf "\n"
		fi
	done	
}

# function for processing the given input
input_control () {
	if [ "$REPLY" = "s" ] && [ $PADDLE_1_HEIGHT -le $((24 - PADDLE_HEIGHT)) ]; then
		 (( PADDLE_1_HEIGHT += 1 ))
	fi
	if [ "$REPLY" = "w" ] && [ $PADDLE_1_HEIGHT -ge 1 ]; then
		 (( PADDLE_1_HEIGHT -= 1 ))
	fi
	if [ "$REPLY" = "e" ] && [ $PADDLE_2_HEIGHT -ge 1 ]; then
		 (( PADDLE_2_HEIGHT -= 1 ))
	fi
	if [ "$REPLY" = "d" ] && [ $PADDLE_2_HEIGHT -le $((24 - PADDLE_HEIGHT)) ]; then
		 (( PADDLE_2_HEIGHT += 1 ))
	fi

}

# function for updating the direction the ball is going in
update_ball_direction () {
	if [ $BALL_X_POS -ge $(( 80 - PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_2_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_2_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=0
	fi
	if [ $BALL_X_POS -le $(( 1 + PADDLE_WIDTH )) ] && [ $BALL_Y_POS -ge $PADDLE_1_HEIGHT ] && [ $BALL_Y_POS -le $(( PADDLE_1_HEIGHT + PADDLE_HEIGHT )) ]; then
		BALL_X_MOV=1
	fi

	if [ $BALL_Y_POS -ge 25 ]; then 
		BALL_Y_MOV=0
	elif [ $BALL_Y_POS -le 1 ]; then 
		BALL_Y_MOV=1
	fi
}

# function for updating the ball's position
update_ball_position () {
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
}

# function for moving the terminal cursor and printing the ball
print_ball () {
	printf "\033[%d;%df" "$BALL_Y_POS" "$BALL_X_POS" 
	printf "%c" "$1"
}

# function for moving the terminal cursor and printing the paddles
print_paddles () {
	printf "\033[%d;0f" "$PADDLE_1_HEIGHT"
	for y in {1..10..1}			# y paddle loop
	do
		for x in {1..3..1}					# x paddle loop
		do
			# put paddle character
			printf "%c" "$1"
		done
	printf "\n"
	done

	printf "\033[%d;78f" "$PADDLE_2_HEIGHT"
	for y in {1..10..1}			# y paddle loop
	do
		for x in {1..3..1}					# x paddle loop
		do
			# put paddle character
			printf "%c" "$1"
		done
		printf "\033[%d;78f" "$((y + PADDLE_2_HEIGHT))"
	done
}

game_init () {
	clear
	stty -icanon -echo
	fill_background
}

############################################################################################################################################
# main game loop

game_init

# game loop
while :
do

	print_ball $BALL_CHARACTER
	print_paddles $PADDLE_CHARACTER
	
	# read one character
	read -n1 -t 0.1;

	print_ball $BACKGROUND_CHARACTER
	print_paddles $BACKGROUND_CHARACTER
	input_control
	update_ball_direction
	
	# check if ball is out of bounds
	if [ $BALL_X_POS -ge 80 ]; then 
		break
	fi
	if [ $BALL_X_POS -le 1 ]; then 
		break
	fi
	
	update_ball_position
done

printf "\033[26;0f"
printf "Game over!\n" 
stty icanon echo
############################################################################################################################################
