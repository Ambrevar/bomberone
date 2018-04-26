#!guile \
-e main -s
!#

;; TODO: Size background properly when windowed: looks like we need to load
;; background first and get its dimensions.

(use-modules (sdl2)
             (system foreign)
             ((sdl2 render) #:prefix sdl:)
             ((sdl2 bindings) #:prefix SDL:)
             ((sdl2 events) #:prefix sdl:)
             ((sdl2 image) #:prefix sdl:)
             ((sdl2 surface) #:prefix sdl:)
             ((sdl2 video) #:prefix sdl:))

(define *fps* 60)
(define *running?* #f)
(define *player* #f)
(define *background* #f)

(define* (render-copy renderer texture #:optional srcrect dstrect)
  "Copy TEXTURE to the rendering target of RENDERER."
  (let ((result (SDL:sdl-render-copy ((@@ (sdl2 render) unwrap-renderer) renderer)
                                     ((@@ (sdl2 render) unwrap-texture) texture)
                                     (or (and srcrect
                                              (make-c-struct (list int int int int)
                                                             srcrect))
                                         %null-pointer)
                                     (or (and dstrect
                                              (make-c-struct (list int int int int)
                                                             dstrect))
                                         %null-pointer))))
    (unless (zero? result)
      (sdl-error "render-copy" "failed to copy texture"))))

(define (process-event event)
  (when event
    (cond
     ((sdl:keyboard-down-event? event)
      (case (sdl:keyboard-event-scancode event)
        ((q Q)
         (set! *running?* #f)
         (sdl-quit))))
     ((sdl:keyboard-up-event? event)
      (display "up ")))))

(define (draw ren)
  (let ((player-texture (sdl:surface->texture ren *player*))
        (background-texture (sdl:surface->texture ren *background*)))
    ;; TODO: Can we get window from renderer?
    ;; TODO: Why do we specify "ren" in surface->texture?  Maybe because of hardware specificities.

    (define update-interval (round (/ 1000 *fps*)))
    ;; TODO: Account for lag.
    (let loop ((previous-time (sdl-ticks)))
      (let ((current-time (sdl-ticks)))
        (if (>= (- current-time previous-time) update-interval)
            (begin
              (process-event (sdl:poll-event))
              (set! previous-time current-time))
            (begin
              (sdl:clear-renderer ren)
              (render-copy ren background-texture)
              (render-copy ren player-texture #f '(0 0 32 32))
              (sdl:present-renderer ren)))
        (when *running?*
          (loop current-time))))))

;; ;; TODO: Use OS separator.
;; (define player (SDL:load-image (string-append image-dir "/character.png")))
;; (define player-pos (SDL:make-rect 0 0 32 32))
;; (define* (move-player #:optional (distance 1))
;;   (SDL:rect:set-x! player-pos (+ (SDL:rect:x player-pos) distance))
;;   (SDL:blit-surface player #f (SDL:get-video-surface) player-pos))

;; TODO: repl + running?
;; TODO: Options? (fps)

(define* (main #:optional args)
  (sdl-init)
  (set! *running?* #t)
  (set! *background* (sdl:load-image "textures/background.png"))
  (set! *player* (sdl:load-image "textures/character.png"))
  (sdl:call-with-window (sdl:make-window #:title "Bomberone"
                                         ;; #:fullscreen-desktop? #t
                                         #:size (list (sdl:surface-width *background*)
                                                      (sdl:surface-height *background*)))
                        (lambda (window)
                          (sdl:call-with-renderer (sdl:make-renderer window) draw)))
  (sdl-quit))
