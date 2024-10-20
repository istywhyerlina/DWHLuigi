INSERT INTO stg.order_reviews 
    (review_id, order_id, review_score,review_comment_title,review_comment_message,review_creation_date) 

SELECT
    review_id, order_id, review_score,review_comment_title,review_comment_message,review_creation_date
FROM
    olist.order_reviews

ON CONFLICT(review_id,order_id) 
DO UPDATE SET
    review_score = EXCLUDED.review_score,
    review_comment_title = EXCLUDED.review_comment_title,
    review_comment_message = EXCLUDED.review_comment_message,
    review_creation_date = EXCLUDED.review_creation_date,
    updated_at = CASE WHEN 
                        stg.order_reviews.review_score <> EXCLUDED.review_score
                        OR stg.order_reviews.review_comment_title <> EXCLUDED.review_comment_title
                        OR stg.order_reviews.review_comment_message <> EXCLUDED.review_comment_message
                        OR stg.order_reviews.review_creation_date <> EXCLUDED.review_creation_date
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.order_reviews.updated_at
                END;