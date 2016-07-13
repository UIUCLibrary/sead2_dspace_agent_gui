class DepositsController < ApplicationController
  before_action :set_deposit, only: [:show, :edit, :update, :destroy]

  # GET /deposits
  # GET /deposits.json
  def index
    @deposits = Deposit.all
  end

  # GET /deposits/1
  # GET /deposits/1.json
  def show
    @deposit = Deposit.find( params[:id] )
    @research_object = @deposit.research_objects.first # TODO: make sure there will only be one of these!!!
    @aggregated_resources = @research_object.aggregated_resources
    t = true
  end

  # GET /deposits/new
  def new
    @deposit = Deposit.new
  end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deposits/1
  # PATCH/PUT /deposits/1.json
  def update
    respond_to do |format|
      if @deposit.update(deposit_params)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /deposits/1/accept
  def accept
    @deposit = Deposit.find(params[:id])
    @research_object = @deposit.research_objects.first # TODO: make sure there will only be one of these!!!
    @aggregated_resources = @research_object.aggregated_resources
    # if accept = true then run code to process the ro
    # else run code to reject it
    if @deposit.update(deposit_params)

      if @deposit.deposit_license_accepted

        #TODO: send RO to dspace!

        redirect_to deposits_url, notice: "Deposit #{@deposit.id} accepted!"
      else
        flash['error'] = 'You must grant the IDEALS Distribution License in order to deposit!'
        respond_to do |format|
          format.html { render :show }
          format.json { render json: @deposit.errors, status: :unprocessable_entity }
        end
        render :show
      end

    else
      respond_to do |format|
        format.html { render :show }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    @deposit = Deposit.find( params[:id] )
    redirect_to deposits_url, notice: "Deposit #{@deposit.id} rejected!"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def deposit_params
    params.require(:deposit).permit(:deposit_license_accepted)
  end
end