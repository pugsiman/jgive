# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
campaign = Campaign.find_by(title: "Community Food Relief") ||
           Campaign.find_by(title: "הגן הכתום") ||
           Campaign.new
campaign.update!(
  title: "הגן הכתום",
  story: <<~STORY.squish,
    הגן הכתום הוקם כדי לסייע למשפחות וילדים שזקוקים לתמיכה יציבה, חמה ומכבדת.
    התרומות מאפשרות לנו לספק מזון, ציוד בסיסי, פעילויות לילדים וליווי למשפחות בתקופות מאתגרות.

    כל תרומה, גדולה או קטנה, מצטרפת למאמץ משותף שמעניק למשפחות תחושת ביטחון וקהילה.
    הכספים שייאספו בקמפיין ישמשו לרכישת מצרכים, ציוד לימודי, משחקים ותמיכה שוטפת עבור הילדים.

    ביחד נוכל להמשיך להפעיל את הגן הכתום, לשמור על רצף הפעילות, ולהגיע לעוד משפחות שצריכות אותנו עכשיו.
  STORY
  goal_amount_cents: 50_000_00
)

[
  {
    user_email: "miriam@example.com",
    donor_first_name: "מרים",
    donor_last_name: "כהן",
    amount_cents: 7_500,
    donor_display_preference: "first_name_only",
    dedication_message: "לכבוד המתנדבים שמחזיקים את הפעילות יום יום."
  },
  {
    user_email: "avi@example.com",
    donor_first_name: "אבי",
    donor_last_name: "לוי",
    amount_cents: 12_000,
    donor_display_preference: "anonymous",
    dedication_message: "למען המשפחות והילדים של הגן הכתום."
  }
].each do |attributes|
  donation = campaign.donations.find_or_initialize_by(
    user_email: attributes[:user_email],
    dedication_message: attributes[:dedication_message]
  )
  donation.update!(
    amount_cents: attributes[:amount_cents],
    donor_first_name: attributes[:donor_first_name],
    donor_last_name: attributes[:donor_last_name],
    giving_frequency: "one_time",
    donor_display_preference: attributes[:donor_display_preference],
    state: "paid"
  )
end

amounts_by_email = campaign.donations.group(:user_email).sum(:amount_cents)
counts_by_email = campaign.donations.group(:user_email).count

campaign.campaign_donation_stats.where.not(user_email: amounts_by_email.keys).destroy_all
amounts_by_email.each do |user_email, amount_cents|
  campaign.campaign_donation_stats.find_or_initialize_by(user_email: user_email).update!(
    amount_cents: amount_cents,
    donations_count: counts_by_email.fetch(user_email)
  )
end

puts "Seeded campaign: #{campaign.title}"
