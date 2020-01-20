on run argv


set appleMusicURL to (item 1 of argv)

    -- open and go to website
    tell application "Google Chrome" to activate
		
		open location appleMusicURL


end run