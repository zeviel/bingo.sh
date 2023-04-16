#!/bin/bash

api="https://invest.divweb.ru/api"
sign=null
vk_user_id=null
vk_ts=null
vk_ref=null
user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36"

function authenticate() {
	# 1 - sign: (string): <sign>
	# 2 - vk_user_id: (integer): <vk_user_id>
	# 3 - vk_ts: (integer): <vk_ts>
	# 4 - vk_ref: (string): <vk_ref>
	# 5 - access_token_settings: (string): <access_token_settings - default: >
	# 6 - are_notifications_enabled: (integer): <are_notifications_enabled: default: 0>
	# 7 - is_app_user: (integer): <is_app_user - default: 0>
	# 8 - is_favorite: (integer): <is_favorite - default: 0>
	# 9 - language: (string): <language - default: ru>
	# 10 - platform: (string): <platform - default: desktop_web>
	sign=$1
	vk_user_id=$2
	vk_ts=$3
	vk_ref=$4
	params="vk_access_token_settings=${5:-}&vk_app_id=7766223&vk_are_notifications_enabled=${6:-0}&vk_is_app_user=${7:-0}&vk_is_favorite=${8:-0}&vk_language=${9:-ru}&vk_platform=${10:-desktop_web}&vk_ref=$vk_ref&vk_ts=$vk_ts&vk_user_id=$vk_user_id&sign=$sign"
	echo $params
}

function app_init() {
	curl --request GET \
		--url "$api/init/" \
		--user-agent "$user_agent" \
		--header "xvk: $params"
}

function get_popular() {
	curl --request GET \
		--url "$api/getPopular/" \
		--user-agent "$user_agent" \
		--header "xvk: $params"
}

function get_new() {
	curl --request GET \
		--url "$api/getNew/" \
		--user-agent "$user_agent" \
		--header "xvk: $params"
}

function like_bingo() {
	# 1 - bingo_id: (string): <bingo_id>
	# 2 - like: (boolean): <true, false - default: true>
	curl --request POST \
		--url "$api/like/$1" \
		--user-agent "$user_agent" \
		--header "xvk: $params" \
		--data '{
			"like": '${2:-true}'
		}'
}


function report_bingo() {
	# 1 - bingo_id: (string): <bingo_id>
	# 2 - reason: (string): <reason>
	# 3 - comment: (string): <comment - default: "">
	curl --request POST \
		--url "$api/claim/$1" \
		--user-agent "$user_agent" \
		--header "xvk: $params" \
		--data '{
			"reason": "'$2'",
			"comment": '${3:-""}'
		}'
}

function delete_bingo() {
	# 1 - bingo_id: (string): <bingo_id>
	curl --request GET \
		--url "$api/delete/$1" \
		--user-agent "$user_agent" \
		--header "xvk: $params"
}
