#!guile \
-e main -s
!#

(use-modules (sdl2)
             ((sdl2 render) #:prefix sdl:)
             ((sdl2 image) #:prefix sdl:)
             ((sdl2 surface) #:prefix sdl:)
             ((sdl2 video) #:prefix sdl:))

(define (draw ren)
  (let* ((surface (sdl:load-image "textures/background.png"))
         (texture (sdl:surface->texture ren surface)))
    ;; TODO: Why do we specify "ren" twice?
    (sdl:clear-renderer ren)
    (sdl:render-copy ren texture)
    (sdl:present-renderer ren)
    (sleep 2)))

;; ;; TODO: Use OS separator.
;; (define player (SDL:load-image (string-append image-dir "/character.png")))
;; (define player-pos (SDL:make-rect 0 0 32 32))
;; (define* (move-player #:optional (distance 1))
;;   (SDL:rect:set-x! player-pos (+ (SDL:rect:x player-pos) distance))
;;   (SDL:blit-surface player #f (SDL:get-video-surface) player-pos))

(define (main)
  (sdl-init)
  (sdl:call-with-window (sdl:make-window)
                    (lambda (window)
                      (sdl:call-with-renderer (sdl:make-renderer window) draw)))

  (sdl-quit))
