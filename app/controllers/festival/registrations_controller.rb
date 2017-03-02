class Festival::RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, except: [:new, :create]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    @registration = Registration.new
    @registration.students.build
  end

  # GET /registrations/1/edit
  def edit
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)

    respond_to do |format|
      if @registration.fee_waiver?

        # Process registration without fees.
        if @registration.save_without_payment
          NotificationMailer.registration_confirmation(@registration).deliver
          format.html { redirect_to root_url, notice: "Your registration was successfully created. A confirmation was sent to #{@registration.email}." }
        else
          format.html { render action: "new" }
        end
      else
        # Process registration with payment
        if @registration.save_with_payment
          NotificationMailer.registration_confirmation(@registration).deliver
          format.html { redirect_to root_url(id: @registration.id, charge_id: @registration.stripe_charge_token), notice: "Your registration was successfully created. A confirmation was sent to #{@registration.email}." }
        else
          format.html { render action: "new" }
        end
      end
    end


    rescue Stripe::CardError => e
      redirect_to new_registration_path , alert: e.message + " Please complete your registration with a valid credit card."

    rescue Stripe::InvalidRequestError => e
      redirect_to new_registration_path , alert: e.message + " Please complete your registration with a valid credit card."
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    respond_to do |format|
      if @registration.update(registration_params)
        format.html { redirect_to @registration, notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: @registration }
      else
        format.html { render :edit }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url, notice: 'Registration was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_registration
      @registration = Registration.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:year, :student_count, :fee_waiver, :consent, :stripe_card_token, :stripe_charge_token, :email, :confirmation_code, :total, :first_name, :last_name, :email, :comments, :phone, :school_name, students_attributes: [:id, :first_name, :last_name, :grade, :shirt, :shirt_size, :_destroy])
    end
end
