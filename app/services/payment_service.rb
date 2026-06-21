class PaymentService
  Result = Data.define(:success?, :message)

  def initialize(donation)
    @donation = donation
  end

  def process!
    Result.new(success?: false, message: "Payment integration is not implemented yet.")
  end

  private

  attr_reader :donation
end
