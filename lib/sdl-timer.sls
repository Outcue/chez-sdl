;;;; -*- mode: Scheme; -*-

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Local Procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

(define (make-sdl-timer-callback procedure)
  (let
      ((proc (foreign-callable __collect_safe
			       procedure
			       (unsigned-32 void*)
			       unsigned-32)))
    (lock-object proc)
    (foreign-callable-entry-point proc)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; C Function Bindings ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define *sdl-add-timer*                 (sdl-procedure "SDL_AddTimer" (unsigned-32 void* void*) int))
(define *sdl-delay*                     (sdl-procedure "SDL_Delay" (unsigned-32) void))
(define *sdl-get-performance-counter*   (sdl-procedure "SDL_GetPerformanceCounter" () unsigned-64))
(define *sdl-get-performance-frequency* (sdl-procedure "SDL_GetPerformanceFrequency" () unsigned-64))
(define *sdl-get-ticks*                 (sdl-procedure "SDL_GetTicks" () unsigned-32))
(define *sdl-remove-timer*              (sdl-procedure "SDL_RemoveTimer" (int) int))


;;;;;;;;;;;;;;;;;;;
;;; Marshalling ;;;
;;;;;;;;;;;;;;;;;;;

(define sdl-delay                     *sdl-delay*)
(define sdl-get-performance-counter   *sdl-get-performance-counter*)
(define sdl-get-performance-frequency *sdl-get-performance-frequency*)
(define sdl-get-ticks                 *sdl-get-ticks*)
(define sdl-remove-timer              *sdl-remove-timer*)

(define (sdl-add-timer interval procedure)
  (*sdl-add-timer* interval
		   (make-sdl-timer-callback (lambda (interval param) (procedure interval)))
		   0))
