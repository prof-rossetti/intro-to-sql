/* MIDTERM - DATA ANALYSIS QUESTIONS - ANSWERS

  each question is followed by one or more SQL query approaches
    ... which produce desired results
    ... and are acknowleged for full credit.

*/
-- 1a. Which listener has the email address, 'musicfan101@gmail.com'?

SELECT id
FROM listeners
WHERE email_address = 'musicfan101@gmail.com';

-- 1b. Which listeners have an email address that contains the text, '@gwu.edu'?

SELECT id
FROM listeners
WHERE email_address LIKE '%@gwu.edu%'; -- open source dbms

SELECT id
FROM listeners
WHERE email_address LIKE '*@gwu.edu*'; -- ms access dbms

-- 2a. How long is the longest song?

SELECT max(duration_milliseconds) FROM songs;

-- 2b. How long is the shortest song?

SELECT min(duration_milliseconds) FROM songs;

-- 3a. How many songs have been played?

SELECT count(DISTINCT song_id) AS song_count
FROM plays;

SELECT count(DISTINCT songs.id) AS song_count
FROM songs
JOIN plays on plays.song_id = songs.id;

-- 3b. How many songs have NOT been played?

SELECT count(DISTINCT songs.id) AS unplayed_song_count
FROM songs
LEFT JOIN plays on plays.song_id = songs.id
WHERE plays.song_id IS NULL;

-- 4a. Which listeners have listened to at least one song?

SELECT DISTINCT listeners.id
FROM listeners
JOIN plays on plays.listener_id = listeners.id;

-- 4b. Which listeners have NOT yet listened to a song?

SELECT DISTINCT listeners.id
FROM listeners
LEFT JOIN plays on plays.listener_id = listeners.id
WHERE plays.listener_id IS NULL;

-- 5a. What are the email addresses of the listeners whose credit cards are set to expire during the month of November (11) 2015?

SELECT DISTINCT listeners.email_address
FROM listeners l
JOIN listener_accounts la ON l.id = la.listener_id
WHERE la.cc_exp_month = 11
  AND la.cc_exp_year = 2015;

-- 5b. What are the email addresses of the listeners whose credit cards are set to expire during either the month of November (11) 2015 or December (12) 2015?

SELECT DISTINCT listeners.email_address
FROM listeners l
JOIN listener_accounts la ON l.id = la.listener_id
WHERE (la.cc_exp_month = 11 OR la.cc_exp_month = 12)
  AND la.cc_exp_year = 2015;

SELECT DISTINCT listeners.email_address
FROM listeners l
JOIN listener_accounts la ON l.id = la.listener_id
WHERE la.cc_exp_month > 10
  AND la.cc_exp_year = 2015;

-- 5c. What are the email addresses of the listeners whose credit cards are set to expire during the months of November (11) 2015, December (12) 2015, or January (01) 2016?

SELECT DISTINCT listeners.email_address
FROM listeners l
JOIN listener_accounts la ON l.id = la.listener_id
WHERE (la.cc_exp_month = 11 AND la.cc_exp_year = 2015)
  OR (la.cc_exp_month = 12 AND la.cc_exp_year = 2015)
  OR (la.cc_exp_month = 1 AND la.cc_exp_year = 2016);

-- 6a. How many times has each type of thumb button been pressed?

SELECT
 thumb_type
 ,count(DISTINCT id) as press_count
FROM thumbs
GROUP BY thumb_type;

-- 6b. Which thumb button gets pressed most often?

SELECT
 thumb_type
 ,count(DISTINCT id) as press_count
FROM thumbs
GROUP BY thumb_type
ORDER BY button_press_count DESC
LIMIT 1; -- open source dbms

SELECT TOP 1
 thumb_type
 ,count(DISTINCT id) as button_press_count
FROM thumbs
GROUP BY thumb_type
ORDER BY count(DISTINCT id) DESC; -- ms access DBMS

-- 6c. Which thumb button was pressed most often between '2015-01-01' and '2015-03-15'?

SELECT
 thumb_type
 ,count(DISTINCT id) as button_press_count
FROM thumbs
WHERE thumb_pressed_at BETWEEN '2015-01-01' AND '2015-03-15' -- assumes thumb_pressed_at is a date/datetime/timestamp datatype
GROUP BY thumb_type
ORDER BY button_press_count DESC
LIMIT 1; -- open source dbms

SELECT TOP 1
 thumb_type
 ,count(DISTINCT id) as button_press_count
FROM thumbs
WHERE thumb_pressed_at BETWEEN '2015-01-01' AND '2015-03-15'  -- assumes thumb_pressed_at is a date/datetime/timestamp datatype
GROUP BY thumb_type
ORDER BY count(DISTINCT id) DESC; -- ms access DBMS

SELECT
 thumb_type
 ,count(DISTINCT id) as button_press_count
FROM thumbs
WHERE thumb_pressed_at >= '2015-01-01' AND thumb_pressed_at <= '2015-03-15' -- assumes thumb_pressed_at is a date/datetime/timestamp datatype
GROUP BY thumb_type
ORDER BY button_press_count DESC
LIMIT 1; -- open source dbms

SELECT TOP 1
 thumb_type
 ,count(DISTINCT id) as button_press_count
FROM thumbs
WHERE thumb_pressed_at >= '2015-01-01' AND thumb_pressed_at <= '2015-03-15' -- assumes thumb_pressed_at is a date/datetime/timestamp datatype
GROUP BY thumb_type
ORDER BY count(DISTINCT id) DESC; -- ms access DBMS

-- 7a. How many songs have been skipped?

SELECT count(DISTINCT plays.song_id) as skipped_song_count
FROM skips
JOIN plays on plays.id = skips.play_id;

SELECT count(DISTINCT songs.id) as skipped_song_count
FROM songs
JOIN plays on plays.song_id = songs.id
JOIN skips on skips.play_id = plays.id;

---7b. How many songs have NOT been skipped?

SELECT count(DISTINCT songs.id) as nonskipped_song_count
FROM songs
LEFT JOIN plays on plays.song_id = songs.id
LEFT JOIN skips on skips.play_id = plays.id
WHERE skips.id IS NULL;

-- 7c. Which 100 songs have been skipped the most?

SELECT
  songs.id
  ,count(DISTINCT skips.id) as skip_count
FROM songs
JOIN plays on plays.song_id = songs.id
JOIN skips on skips.play_id = plays.id
GROUP BY songs.id
ORDER BY skip_count DESC
LIMIT 100; -- open source dbms

SELECT TOP 100
  songs.id
  ,count(DISTINCT skips.id) as skip_count
FROM songs
JOIN plays on plays.song_id = songs.id
JOIN skips on skips.play_id = plays.id
GROUP BY songs.id
ORDER BY skip_count DESC; -- ms access dbms
