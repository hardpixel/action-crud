module ActionCrud
  module Controller
    extend ActiveSupport::Concern

    included do
      # Class attributes
      class_attribute :model_name
      class_attribute :model_index_scope
      class_attribute :permitted_parameters

      self.model_name = self.controller_name

      # Action callbacks
      before_action :set_record, only: [:show, :edit, :update, :destroy]
    end

    class_methods do
      # Set permitted parameters
      def permit_parameters(*args)
        model     = self.model_name.classify.constantize
        options   = args.extract_options!
        default   = args.any? ? args : model.attribute_names
        excluded  = [:id, :created_at, :updated_at]
        only      = options.fetch(:only, default)
        also      = options.fetch(:also, [])
        array     = options.fetch(:array, [])
        hash      = options.fetch(:hash, [])
        except    = options.fetch(:except, []).concat(excluded)
        permitted = only.reject { |a| a.in? except }.concat(also).concat(array).concat(hash)
        permitted = permitted.uniq.map { |e| e.in?(array) ? [e => []] : e }
        permitted = permitted.uniq.map { |e| e.in?(hash) ? [e => {}] : e }

        self.permitted_parameters = permitted
      end

      # Set index scope
      def index_scope(scope_name)
        self.model_index_scope = scope_name
      end
    end

    # GET /model
    def index
      if self.model_index_scope
        collection = model.send self.model_index_scope
      else
        collection = model.all
      end

      self.records = collection

      respond_to do |format|
        format.html { render :index }
        format.json { render json: records }
      end
    end

    # GET /model/new
    def new
      self.record = model.new

      respond_to do |format|
        format.html { render :new }
        format.json { render json: record }
      end
    end

    # GET /model/1
    def show
      respond_to do |format|
        format.html { render :show }
        format.json { render json: record }
      end
    end

    # GET /model/1/edit
    def edit
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: record }
      end
    end

    # POST /model
    def create
      self.record = model.new(record_params)

      respond_to do |format|
        if record.save
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully created." }
          format.json { render json: record, status: :created }
        else
          format.html { render :new }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /model/1
    def update
      respond_to do |format|
        if record.update(record_params)
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully updated." }
          format.json { render json: record, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /model/1
    def destroy
      record.destroy
      respond_to do |format|
        format.html { redirect_to index_record_path, notice: "#{model} was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # Get model
    def model
      model_name.classify.constantize
    end

    # Get single record
    def record
      instance_variable_get "@#{singular_name}"
    end

    # Get records collection
    def records
      instance_variable_get "@#{plural_name}"
    end

    private

      # Get singular name
      def singular_name
        model_name.demodulize.singularize
      end

      # Get plural name
      def plural_name
        model_name.demodulize.pluralize
      end

      # Set single record
      def record=(value)
        instance_variable_set "@#{singular_name}", value
      end

      # Set records collection
      def records=(value)
        instance_variable_set "@#{plural_name}", value
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_record
        self.record = model.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def record_params
        params.require(:"#{singular_name}").permit self.permitted_parameters
      end
  end
end
