#!guile \
-e main -s
!#

;; TODO: Add prefix.
(use-modules (sdl2)
             (sdl2 render)
             (sdl2 image)
             (sdl2 surface)
             (sdl2 video))

(define (draw ren)
  (let* ((surface (load-image "textures/background.png"))
         (texture (surface->texture ren surface)))
    ;; TODO: Why do we specify "ren" twice?
    (clear-renderer ren)
    (render-copy ren texture)
    (present-renderer ren)
    (sleep 2)))

;; ;; TODO: Use OS separator.
;; (define player (SDL:load-image (string-append image-dir "/character.png")))
;; (define player-pos (SDL:make-rect 0 0 32 32))
;; (define* (move-player #:optional (distance 1))
;;   (SDL:rect:set-x! player-pos (+ (SDL:rect:x player-pos) distance))
;;   (SDL:blit-surface player #f (SDL:get-video-surface) player-pos))

(define (main)
  (sdl-init)
  (call-with-window (make-window)
                    (lambda (window)
                      (call-with-renderer (make-renderer window) draw)))

  (sdl-quit))
