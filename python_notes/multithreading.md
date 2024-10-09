MULTITHREADING

useful if your tasks are I/O bound (reading and writing files, for example)
Or if your tasks only require a little bit of computation and then a lot of waiting around for the CPU

While the CPU is waiting for some task to finish, it can start another task.
Each of those tasks is its own thread?

So, the CPU is still working on one task at a time

Yes, once a future object is created by submitting a task with submit() in ThreadPoolExecutor or ProcessPoolExecutor, the computation typically starts running immediately (or as soon as a worker thread or process is available). The future object itself does not perform the computation but is a placeholder for the result that will eventually become available.
