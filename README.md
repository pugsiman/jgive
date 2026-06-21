# Live app link: https://jgive.onrender.com/

# Setup
```bash
bundle install
rails db:create db:migrate db:seed
rails server
```

# User transcript (codex)
https://github.com/pugsiman/jgive/blob/main/codex-user-prompts.md

# General approach
I set up the project with the rails CLI using the settings, gems etc. I want. I then give the LLM instructions to brainstorm the design phase of the backend. I try to be explicit in the entities and APIs I want. I then make some changes, simplify etc. where I think is necessary or helpful. I rewrite most of the specs as the LLM tends to overspecify and write brittle tests. Then let the LLM to do another pass on its own. For the UI I let it do its thing more or less, with guiding prompts on visual direction and bugs. 

# Payment implementation
Standard approach I believe: the donation creates a record with `'pending'` state and an `Intention` of payment. We let the payment provider know about the intention and pass back some uid (IIRC) to the user, so they can authorize with the payment service directly. Once the user pays and let us know it worked, we query the payment provider to confirm. If it does, we transition the donation to `'paid'` in the DB (this can also be done through a webhook, an async background job, and other architectures)
