extends Node3D
class_name ThreadPool

var exitThread : bool
var pool : Array[Thread]
var tasks : Array[Callable]
var mutex : Mutex
var semaphore : Semaphore

func _init(_size : int) -> void:
  exitThread = false
  mutex = Mutex.new()
  semaphore = Semaphore.new()

  for i in range(_size):
    var thread : Thread = Thread.new()
    thread.start(ExecuteTasks, Thread.PRIORITY_NORMAL)
    pool.append(thread)

func ExecuteTasks() -> void:
  while true:
    semaphore.wait()

    mutex.lock()
    var shouldExit : bool = exitThread
    mutex.unlock()

    if shouldExit: break

    mutex.lock()
    var task : Callable = tasks.pop_front()

    if task:
      task.call()

    mutex.unlock()

func QueueTask(_task : Callable) -> void:
  mutex.lock()
  tasks.append(_task)
  mutex.unlock()

  semaphore.post()

func WidthdrawPool() -> void:
  mutex.lock()
  exitThread = true
  mutex.unlock()


  for thread in pool:
    semaphore.post()
    thread.wait_to_finish()