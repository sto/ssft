#!/bin/sh -e
# --------
# File:        ssft_tests.sh
# Description: Script to test the ssft funtions
# Author:      Sergio Talens-Oliag <sto@debian.org>
# Copyright:   (c) 2005-2016 Sergio Talens-Oliag <sto@debian.org>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along 
# with this program; if not, write to the Free Software Foundation, Inc., 
# 51 Franklin St, Fifth Floor, Boston MA 02110-1301 USA
# --------

if [ -f ../src/ssft.sh ]; then
  . ../src/ssft.sh || exit 1
else
  . ssft.sh || exit 1
fi

TEXTDOMAIN="ssft"

ssft_sh_frontend_tests() {
  progname="$0"
  RES="`gettext "Result"`"
  CANCEL="`gettext "The user CANCELLED the operation"`"
  
  if [ $# -lt 1 ]; then
    MSG=$(eval_gettext "Usage: \$progname FRONTENDS

Where FRONTENDS is one or more of zenity, kdialog, dialog, text or noninteractive")
    echo "$MSG"
    return 0
  fi
  FRONTENDS=""
  for f in $@; do
    # Remove duplicates
    for af in $FRONTENDS; do
      if [ "$af" = "$f" ]; then
        f=""; break;
      fi
    done
    # Add to FRONTENDS
    case $f in
    zenity|kdialog|dialog|text|noninteractive)
      FRONTENDS="$FRONTENDS $f"
    ;;
    esac
  done
  for frontend in $FRONTENDS; do
    export SSFT_FRONTEND="$frontend"
    MSG=$(eval_gettext "TESTING FRONTEND '\$frontend'")
    echo "$MSG"
    echo ""
    echo "-------------------------------"
    echo "ssft_display_message"
    echo "-------------------------------"
    echo ""
    TIT="`gettext "Display message test"`"
    MSG="`gettext "This is a simple message
It is shown using ssft_display_message"`" 
    ssft_display_message "$TIT" "$MSG"
    echo "-----------------------------"
    echo "ssft_display_error"
    echo "-----------------------------"
    echo ""
    TIT="`gettext "Display error test"`"
    MSG="`gettext "This is an error message
It is shown using ssft_display_error"`"
    ssft_display_error "$TIT" "$MSG"
    echo "------------------------------"
    echo "ssft_file_selection"
    echo "------------------------------"
    echo ""
    TIT="`gettext "Select a file"`"
    MSG="`gettext "Choose a file, please!"`"
    if ssft_file_selection "$TIT" "$MSG"; then
      MSG=$(eval_gettext "The user said: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "------------------------------"
    echo "ssft_directory_selection"
    echo "------------------------------"
    echo ""
    TIT="`gettext "Select a directory"`"
    MSG="`gettext "Choose a directory, please!"`"
    if ssft_directory_selection "$TIT" "$MSG"; then
      MSG=$(eval_gettext "The user said: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "----------------------------"
    echo "ssft_progress_bar"
    echo "----------------------------"
    echo ""
    TIT="`gettext "Sample PROGRESSBAR"`"
    if ! (
      for x in `seq 0 20 100`; do \
        MSG=$(eval_gettext "We are at \$x %"); \
        echo "$x"; echo "$MSG"; sleep 1; \
      done | ssft_progress_bar "$TIT" ); then
      ssft_display_message "$RES" "$CANCEL"
    fi
    echo "---------------------------"
    echo "ssft_read_string"
    echo "---------------------------"
    echo ""
    TIT="`gettext "Read STRING"`"
    MSG="`gettext "Gimme a string"`"
    if ssft_read_string "$TIT" "$MSG"; then
      MSG=$(eval_gettext "The user said: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "---------------------------"
    echo "ssft_read_string (defaults)"
    echo "---------------------------"
    echo ""
    SSFT_DEFAULT="default string"
    TIT="`gettext "Read STRING"`"
    MSG="`gettext "Gimme a string"`"
    if ssft_read_string "$TIT" "$MSG"; then
      MSG=$(eval_gettext "The user said: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-----------------------------"
    echo "ssft_read_password"
    echo "-----------------------------"
    echo ""
    TIT="`gettext "Read PASSWD"`"
    MSG="`gettext "Gimme a password"`"
    if ssft_read_password "$TIT" "$MSG"; then
      MSG=$(eval_gettext "The user said: '\$SSFT_RESULT'");
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-------------------------------"
    echo "ssft_select_multiple"
    echo "-------------------------------"
    echo ""
    TIT="`gettext "Select MULTIPLE"`"
    MSG="`gettext "Select ONE or MORE Distributions"`"
    OPTS="Debian LliureX Mandrake RedHat Slackware SuSE Ubuntu"
    if ssft_select_multiple "$TIT" "$MSG" $OPTS; then
      MSG=$(eval_gettext "The user selected: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-------------------------------"
    echo "ssft_select_multiple (defaults)"
    echo "-------------------------------"
    echo ""
    SSFT_DEFAULT="Debian
LliureX
Ubuntu"
    TIT="`gettext "Select MULTIPLE"`"
    MSG="`gettext "Select ONE or MORE Distributions"`"
    OPTS="Debian LliureX Mandrake RedHat Slackware SuSE Ubuntu"
    if ssft_select_multiple "$TIT" "$MSG" $OPTS; then
      MSG=$(eval_gettext "The user selected: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-----------------------------"
    echo "ssft_select_single"
    echo "-----------------------------"
    echo ""
    TIT="`gettext "Select SINGLE"`"
    MSG="`gettext "Select ONE Distribution"`"
    OPTS="Debian LliureX Mandrake RedHat Slackware SuSE"
    if ssft_select_single "$TIT" "$MSG" $OPTS; then
      MSG=$(eval_gettext "The user selected: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-----------------------------"
    echo "ssft_select_single (defaults)"
    echo "-----------------------------"
    echo ""
    SSFT_DEFAULT="Slackware"
    TIT="`gettext "Select SINGLE"`"
    MSG="`gettext "Select ONE Distribution"`"
    OPTS="Debian LliureX Mandrake RedHat Slackware SuSE"
    if ssft_select_single "$TIT" "$MSG" $OPTS; then
      MSG=$(eval_gettext "The user selected: '\$SSFT_RESULT'")
    else
      MSG="$CANCEL"
    fi
    ssft_display_message "$RES" "$MSG"
    echo "-------------------------"
    echo "ssft_show_file"
    echo "-------------------------"
    echo ""
    TIT="`gettext "Showing the source code of this test"`"
    if ssft_show_file "$TIT" "$script_file"; then
      MSG=$(eval_gettext "The file '\$script_file' was shown")
    else
      MSG=$(eval_gettext "The file '\$script_file' was NOT shown")
    fi
    ssft_display_message "$RES" "$MSG"
    echo "---------------------"
    echo "ssft_yesno"
    echo "---------------------"
    echo ""
    TIT="`gettext "Title for Yes/No Question"`"
    MSG="`gettext "All was OK?"`"
    if ssft_yesno "$TIT" "$MSG"; then
      MSG="`gettext "The user said YES"`"
    else
      MSG="`gettext "The user said NO"`"
    fi
    ssft_display_message "$RES" "$MSG"
  done
}

# Main program
script_file="$0"
ssft_sh_frontend_tests "$@"

# ------
# SVN Id: $Id: ssft-test.sh 86 2009-07-13 22:48:13Z sto $
