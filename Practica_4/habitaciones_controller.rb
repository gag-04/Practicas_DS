
class HabitacionesController < ActionController::API
  before_action :set_habitacion, only: [:show, :update, :destroy]

  # GET /habitaciones
  def index
    if params[:id].present?
      @habitaciones = Habitacion.where(id: params[:id])
    else
      @habitaciones = Habitacion.all
    end

    render json: @habitaciones
  end

  # GET /habitaciones/:id
  def show
    render json: @habitacion
  end

  # POST /habitaciones
  def create
    @habitacion = Habitacion.new(habitacion_params)
    if @habitacion.save
      render json: @habitacion, status: :created
    else
      render json: @habitacion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /habitaciones/:id
  def update
    if @habitacion.update(habitacion_params)
      render json: @habitacion
    else
      render json: @habitacion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /habitaciones/:id
  def destroy
    if @habitacion.destroy
      head :ok
    else
      render json: { error: "No se pudo eliminar" }, status: :unprocessable_entity
    end
  end

  private

  def set_habitacion
    @habitacion = Habitacion.find_by(id: params[:id])
    render json: { error: "Habitación no encontrada" }, status: :not_found unless @habitacion
  end

  def habitacion_params
    params.require(:habitacion).permit(:capacidad, :precio, :esta_ocupada)
  end
end
