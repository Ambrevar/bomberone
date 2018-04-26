#!guile \
-e main -s
!#

;; TODO: Size background properly when windowed: looks like we need to load
;; background first and get its dimensions.

(use-modules (sdl2)
             ((sdl2 render) #:prefix sdl:)
             ((sdl2 events) #:prefix sdl:)
             ((sdl2 image) #:prefix sdl:)
             ((sdl2 surface) #:prefix sdl:)
             ((sdl2 video) #:prefix sdl:))

(define (draw ren)
  (let* ((surface (sdl:load-image "textures/background.png"))
         (texture (sdl:surface->texture ren surface)))
    ;; TODO: Can we get window from renderer?
    ;; (sdl:set-window-size! window (list (sdl:surface-width surface) (sdl:surface-height surface)))
    ;; TODO: Why do we specify "ren" in surface->texture?  Maybe because of hardware specificities.
    (let loop ((e (sdl:poll-event)))
      (cond
       ((sdl:keyboard-down-event? e)
        (display "down "))
       ((sdl:keyboard-up-event? e)
        (display "up ")))
      (sdl:clear-renderer ren)
      (sdl:render-copy ren texture)
      (sdl:present-renderer ren)
      (sleep 1)
      (loop (sdl:poll-event)))))

;; ;; TODO: Use OS separator.
;; (define player (SDL:load-image (string-append image-dir "/character.png")))
;; (define player-pos (SDL:make-rect 0 0 32 32))
;; (define* (move-player #:optional (distance 1))
;;   (SDL:rect:set-x! player-pos (+ (SDL:rect:x player-pos) distance))
;;   (SDL:blit-surface player #f (SDL:get-video-surface) player-pos))

;; TODO: repl + running?
;; TODO: Options (fps)

(define* (main #:optional args)
  (sdl-init)
  (sdl:call-with-window (sdl:make-window ;; #:fullscreen-desktop? #t
                                         #:size '(460 460))
                        (lambda (window)
                          (sdl:call-with-renderer (sdl:make-renderer window) draw)))
  (sdl-quit))
