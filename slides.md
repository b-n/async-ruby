---
theme: default
background: https://source.unsplash.com/collection/94734566/1920x1080
# show line numbers in code blocks
lineNumbers: true
info: |
  ## Async Ruby
  A ⚡ talk about Async in Ruby 3.x

  Source: [github.com/b-n/async-ruby](https://github.com/b-n/async-ruby)
---

# Async Ruby

## A ⚡ talk about async in Ruby 3.x

---
layout: center
---

# LIVE CODING TIME

<!--
Let's just async some code - straight to live coding
- Take the existing non async code, make it async
- Wrap the run command with Sync - We need to provide an execution context for future
- Wrap the async tasks in a barrier. We want to put a border around them to specify where we are going to start making parallel calls
- Add some rate limiting. We could async all the tasks at once, but that might hit GH APIs too much.
  - We use a semaphore - fancy name to wrap some concurrent tasks
  - Our semaphore will enable a max of 5 of these tasks at once. When the first completes, the next gets added.
-->
---
layout: center
---

# What just happened?

<br>

### Q: Isn't this just threads?

---
layout: cover
background: './denny-muller-JyRTi3LoQnc-unsplash.jpg'
---

<div class="container text-center">

<p class="text-7xl py-8">
  FIBERS
</p>

<v-clicks>

_Q: Could I have just used threads for this workload?_

**"It Depends - Lots of Devs."**

Do you like race conditions and not having semaphores?

</v-clicks>

</div>

<!--
So that was some fast magic - but we had threads before - who cares?
-->
---

# Threads vs. Fibers

- Thread = CPU controlled execution
- Fibers = VM controlled execution

<img src="/fibers-vs-threads.png" />

Source: https://blog.saeloun.com/2022/03/01/ruby-fibers-101.html

<!--
Instead of relying on the CPU for scheduling and execution, we can now control it with fiber_scheduler
fiber_scheduler is used under the hood in Async gem
-->
---
layout: center
---

# LIVE CODING TIME

---
layout: cover
background: './fly-d-saV-2bnik98-unsplash.jpg'
---

<div class="container">

<p class="text-7xl text-center">
  Ractors
</p>

</div>

---
layout: center
---

<img src="/6uag29.jpg" />

<!--
Being realistic here, we could spend a lot of time talking about concurrency vs. parallelism

But let's assume that your application is threaded, or fiber'd, either way, the GIL enforces only
one ruby instruction is being executed at a time. This means you'll only ever have one ruby code
running at a time
-->
---
layout: center
---

<img src="/gears.gif" />

---
layout: center
---

<div class="grid grid-cols-3">

<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />
<img src="/gears.gif" />

</div>

<!--
This is what Ractors unlocks
-->
---
layout: center
---

# LIVE RACTOR TIME

---

## Summary

<v-clicks>

- Fibers can help with concurrency issues
- Async gem is very cool to help with Fibers
- Ractors even cooler - EXPERIMENTAL still
- This talk missed these important things:
  - Failure modes?
  - Real life use cases (apart from scripting)

</v-clicks>

---
layout: cover
---

## Learn More

[This presentation](https://github.com/b-n/async-ruby)

[Slidev](https://sli.dev)

[Threads v Fibres](https://blog.saeloun.com/2022/03/01/ruby-fibers-101.html)

[Ractors](https://www.fullstackruby.dev/ruby-3-fundamentals/2021/01/27/ractors-multi-core-parallel-processing-in-ruby-3/)

--- 

## Acknowledgements

Fibers Photo by <a href="https://unsplash.com/@redaquamedia?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Denny Müller</a> on <a href="https://unsplash.com/s/photos/fiber?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

Ractor Photo by <a href="https://unsplash.com/@flyd2069?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">FLY:D</a> on <a href="https://unsplash.com/s/photos/radiation?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
