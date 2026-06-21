# Donation Campaign Session Summary

This session built the first donation campaign domain and UI for a new Rails 8
server-rendered app backed by PostgreSQL.

## Core Domain

### Campaigns

Implemented in:

- `app/models/campaign.rb`
- `app/controllers/campaigns_controller.rb`
- `app/views/campaigns/index.html.erb`
- `app/views/campaigns/show.html.erb`
- `db/migrate/20260621093200_create_campaigns.rb`

Campaigns include:

- `title`
- `story`
- `goal_amount_cents`
- Active Storage `cover_image`

Campaign behavior:

- `has_many :donations`
- `has_many :campaign_donation_stats`
- `amount_raised_cents` is derived from `campaign_donation_stats`
- `progress_percentage` is derived from `amount_raised_cents / goal_amount_cents`
- `donors_count` is derived from stat rows with a positive donation count

Choice made:

- We store money in integer minor units using `*_cents`. For NIS this maps to
  agorot. Since the app is not doing currency conversion, the naming is
  acceptable for now and avoids migration churn.

### Donations

Implemented in:

- `app/models/donation.rb`
- `app/controllers/donations_controller.rb`
- `db/migrate/20260621093300_create_donations.rb`
- `db/migrate/20260621135123_add_donor_name_to_donations.rb`

Donations include:

- `campaign_id`
- `amount_cents`
- `giving_frequency`
- `donor_display_preference`
- `dedication_message`
- `user_email`
- `donor_first_name`
- `donor_last_name`
- `state`

Donation behavior:

- `belongs_to :campaign`
- normalizes `user_email`
- validates amount, email, and conditional donor names
- allows anonymous donations without first/last name
- updates campaign donation stats after creation

Choice made:

- `Donation` should not act as a form object. It now deals only with persisted
  columns and domain validation.
- Form-only params, `preset_amount` and `custom_amount`, are translated to
  `amount_cents` in `DonationsController`.
- The model no longer contains custom type-casting helpers such as
  `amount_to_cents`, `amount`, or form attr accessors.

## Donation State And Payment Flow

Implemented in:

- `app/models/donation.rb`
- `app/services/payment_service.rb`
- `db/migrate/20260621093300_create_donations.rb`

Choices made:

- Donation state uses a native PostgreSQL enum, `donation_state`.
- Supported states are `pending` and `paid`.
- The database default is `pending`.
- There is no real payment integration yet.
- `PaymentService` exists only to illustrate that payment confirmation will be
  a mandatory part of the future state transition flow.
- The current service intentionally does not transition a donation to `paid`.
- Seeds include a couple of `paid` donations for demonstration data.

Later correction:

- Newly submitted donations should create a pending record and still update the
  campaign's visible progress. The stats callback therefore runs on donation
  creation, regardless of `state`.

## Campaign Donation Stats

Implemented in:

- `app/models/campaign_donation_stat.rb`
- `db/migrate/20260621093400_create_campaign_donation_stats.rb`

Stats table includes:

- `campaign_id`
- `user_email`
- `amount_cents`
- `donations_count`

Choices made:

- A separate stats table is used instead of storing only a campaign-level
  counter. This gives us per-campaign, per-email aggregation and leaves room for
  unique donor counts.
- Stats are updated with `CampaignDonationStat.record_donation!`.
- The unique index on `(campaign_id, user_email)` supports one aggregate row per
  donor email per campaign.
- The donation spec now asserts the callback side effect with a `change` matcher
  on `campaign.campaign_donation_stats.count`, rather than over-specifying the
  aggregate methods there.

## Idempotency Clarification

Choice made:

- Submitting the same donation details twice may be legitimate and should be
  allowed to create two donations.
- We should not deduplicate donations by donor email, amount, or form params.
- A temporary idempotency-key approach was considered and then explicitly
  rejected.
- The correct future idempotency boundary is likely payment-provider events or
  charge IDs, not the donation form submission itself.
- With the current no-payment implementation, no endpoint-level donation
  deduplication was added.

## UI And Frontend

Implemented in:

- `app/views/layouts/application.html.erb`
- `app/views/campaigns/index.html.erb`
- `app/views/campaigns/show.html.erb`
- `app/assets/stylesheets/application.css`
- `app/javascript/controllers/donation_modal_controller.js`
- `app/helpers/campaigns_helper.rb`

Choices made:

- The campaign detail page is server-rendered and styled to roughly match the
  referenced JGive campaign page.
- The donation form is a modal, not embedded inline on the page.
- The primary campaign CTA opens the donation modal through Stimulus.
- The custom amount input is hidden until the donor chooses "other amount".
- The donor first/last name fields disappear and are disabled when the display
  preference is anonymous.
- The fields remain visible for full-name and first-name-only display
  preferences.

The donation form supports:

- preset amounts
- custom amount
- one-time vs recurring
- donor email
- first and last name
- donor display preference
- optional dedication message

## Localization

Implemented in:

- `config/locales/en.yml`
- `config/locales/he.yml`
- `app/controllers/application_controller.rb`
- `config/routes.rb`

Choices made:

- The app supports English and Hebrew locales.
- Hebrew layout direction is handled with `dir="rtl"`.
- Hebrew campaign seed content was added.
- ActiveRecord attribute and validation translations were added for donation
  fields.
- Validation rendering was changed from `full_messages` to each error's
  localized `message`, because `full_messages` prepended field names and made
  Hebrew validation text awkward.

## Seeds

Implemented in:

- `db/seeds.rb`

Choices made:

- Seed data creates or updates a Hebrew campaign.
- Seeds include sample paid donations.
- Seeds rebuild campaign donation stats from existing donations.
- Temporary data-migration files were removed after migrations had run because
  they no longer served a purpose.

## Tooling And Tests

Implemented in:

- `Gemfile`
- `Gemfile.lock`
- `.rubocop.yml`
- `spec/rails_helper.rb`
- `spec/factories/campaigns.rb`
- `spec/factories/donations.rb`
- `spec/factories/campaign_donation_stats.rb`
- `spec/models/campaign_spec.rb`
- `spec/models/donation_spec.rb`
- `spec/requests/campaigns_spec.rb`
- `spec/services/payment_service_spec.rb`

Choices made:

- Added `rubocop` and `rubocop-rails`.
- Did not use `rubocop-rails-omakase`.
- Disabled or tuned cops where they conflicted with project preferences,
  including string literal enforcement.
- Avoided inline RuboCop disable comments such as
  `# rubocop:disable Rails/SkipsModelValidations`.
- Added FactoryBot and moved spec data setup to factories.
- Request specs cover rendering a campaign page and creating a pending donation.
- Model specs cover donation defaults, anonymous donor-name behavior, and stats
  creation side effects.
- Service specs document that `PaymentService` is intentionally not implemented
  yet.

## Database And Infrastructure

Implemented in:

- `config/database.yml`
- `db/schema.rb`
- Active Storage migration

Choices made:

- PostgreSQL is the database.
- Active Storage is enabled for campaign cover images.
- Donation state is a native PostgreSQL enum.
- Monetary values are stored as integer minor units.

## Current Important Behavior

- A campaign has a dedicated page.
- Opening the donation CTA displays a modal.
- Submitting the modal creates a pending donation.
- Pending donations currently update campaign progress immediately.
- Anonymous donations do not require first or last name.
- Choosing anonymous hides and disables first/last name fields in the UI.
- Repeating a donation submit can create another donation; this is allowed.
- Future payment integration should introduce idempotency around provider
  payment events, not around donation form params.
