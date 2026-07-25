class Api::V1::Admin::InquiriesController < Api::V1::AdminController

  before_action :set_inquiry, only: [:show, :update, :destroy]

  def index
    inquiries = Inquiry.includes(:travel_package)
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      inquiries = inquiries.where(
        "full_name LIKE :search OR email :search OR destination LIKE :search",
        search_term
      )
    end
    
    inquiries = inquiries.order(created_at: :desc)
                         .page(params[:page])
                         .per(10)

    render json: {
      inquiries: InquiryBlueprint.render_as_hash(inquiries),
      meta: {
        current_page: inquiries.current_page,
        next_page: inquiries.next_page,
        prev_page: inquiries.prev_page,
        total_pages: inquiries.total_pages,
        total_count: inquiries.total_count
      }
    }
  end

  def show
    render json: InquiryBlueprint.render_as_hash(@inquiry)
  end

  def update
    if @inquiry.update(inquiry_params)
      render json: InquiryBlueprint.render_as_hash(@inquiry)
    else
      render json: { error: @inquiry.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    if @inquiry.destroy
      render json: { message: "Inquiry deleted" }
    else
      render json: { error: @inquiry.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def set_inquiry
    @inquiry = Inquiry.find(params[:id])
  end

  def inquiry_params
    params.require(:inquiry).permit(
      :email,
      :full_name,
      :phone_number,
      :destination,
      :departure_date,
      :return_date,
      :number_of_travelers,
      :estimated_budget,
      :notes,
      :status,
      :travel_package_id
    )
  end
end