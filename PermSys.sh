#!/bin/bash
#  ____                     ____             
# |  _ \ ___ _ __ _ __ ___ / ___| _   _ ___  
# | |_) / _ \ '__| '_ ` _ \\___ \| | | / __| 
# |  __/  __/ |  | | | | | |___) | |_| \__ \ 
# |_|   \___|_|  |_| |_| |_|____/ \__, |___/ 
#                                 |___/      
#  
# by J4v3l (2023)
# "PermSys" is a Bash script for managing user and group permissions on Unix-like systems.
# It offers essential functionality such as adding/removing users, creating/removing groups,
# adding users to groups, and granting group permissions. The script's user-friendly menu
# structure simplifies navigation. It includes a banner with ASCII art and creator information.
# Designed to be concise and efficient, "PermSys" checks for root privileges to ensure secure
# execution. Ideal for system administrators and users needing straightforward command-line
# permission management.
# ----------------------------------------------------- 
banner() {
	cat << "EOF"
 ___               ___         
| _ \___ _ _ _ __ / __|_  _ ___
|  _/ -_) '_| '  \\__ \ || (_-<
|_| \___|_| |_|_|_|___/\_, /__/
                       |__/    
EOF
echo "by J4V3L (2023)"
echo "-----------------------------------------------------"
}

# Function to display a footer
footer() {
    cat <<EOF
-----------------------------------------------------
Thank you for using PermSys!

For support or to contribute, visit:
GitHub: https://github.com/j4v3l/

-----------------------------------------------------
EOF
}

# Function to check and acquire root privileges
check_root() {
	clear
	banner
    if [ "$(id -u)" != "0" ]; then
        echo "This script requires root privileges. Trying to run with sudo..."
        sudo "$0" "$@"
        exit $?
    fi
}

# Call the check_root function
check_root

# Function to add a new user
add_user() {
    read -p "Enter username: " username
    useradd $username
    echo "User $username added."
}

# Function to remove a user
remove_user() {
    read -p "Enter username to remove: " username
    userdel $username
    echo "User $username removed."
}

# Function to list all users
list_all_users() {
    clear
    echo "List of all users"
    current_user=$(whoami)
    echo "--------------------------------------------------"
    printf "| %-25s | %-10s |\n" "Username" "Status"
    echo "--------------------------------------------------"
    awk -F: -v current="$current_user" '{ printf "| %-25s | %-10s |\n", $1, ($1 == current) ? "(You)" : "" }' /etc/passwd
    echo "--------------------------------------------------"
    echo "Press Enter to continue..."
    read -n 1 -s -r
}

# Function to create a new group
create_group() {
    read -p "Enter group name: " groupname
    groupadd $groupname
    echo "Group $groupname created."
}

# Function to remove a group
remove_group() {
    read -p "Enter group name to remove: " groupname
    groupdel $groupname
    echo "Group $groupname removed."
}

# Function to add a user to a group
add_user_to_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    usermod -aG $groupname $username
    echo "User $username added to group $groupname."
}

# Function to list all groups
list_all_groups() {
    clear
    echo "List of all groups"
    current_user=$(whoami)
    echo "----------------------------------------"
    printf "| %-25s | %-10s |\n" "Group Name" "Status"
    echo "----------------------------------------"
    awk -F: -v current="$current_user" '{ printf "| %-25s | %-10s |\n", $1, ($1 == current) ? "(You)" : "" }' /etc/group
    echo "----------------------------------------"
    echo "Press Enter to continue..."
    read -n 1 -s -r
}

# Function to grant permissions to a group
grant_permission_to_group() {
    read -p "Enter group name: " groupname
    read -p "Enter permission (e.g., read, write, execute): " permission
    # Add your permission granting logic here for the group
    echo "Permission $permission granted to group $groupname."
}

# Main menu
while true; do
	clear
	banner
    echo "User and Group Permission Management System"
    echo "1. User Management"
    echo "2. Group Management"
    echo "3. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)   # Submenu for User Management
            while true; do
                clear
                echo "User Management"
                echo "1. Add User"
                echo "2. Remove User"
                echo "3. List All Users"
                echo "4. Back to Main Menu"

                read -p "Enter your choice: " user_choice

                case $user_choice in
                    1) add_user ;;
                    2) remove_user ;;
                    3) list_all_users ;;
                    4) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        2)   # Submenu for Group Management
            while true; do
                clear
                echo "Group Management"
                echo "1. Create Group"
                echo "2. Remove Group"
                echo "3. Add User to Group"
                echo "4. Grant Permission to Group"
                echo "5. List All Groups"
                echo "6. Back to Main Menu"

                read -p "Enter your choice: " group_choice

                case $group_choice in
                    1) create_group ;;
                    2) remove_group ;;
                    3) add_user_to_group ;;
                    4) grant_permission_to_group ;;
                    5) list_all_groups ;;
                    6) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        3) 
            clear
            echo "Exiting..."
			sleep 1
			footer  # Call the footer function
            exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
