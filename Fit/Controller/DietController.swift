//
//  DietController.swift
//  Fit
//
//  Created by Irakli Grigolia on 5/14/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import AVFoundation
import Vision
import UIKit


class DietController: UIViewController, AVCapturePhotoCaptureDelegate {
    var captureSession: AVCaptureSession!
    var backCamera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?

    var shutterButton: UIButton!

  
    var calories = 0
    var carbs = 0
    var fats = 0
    var proteins = 0

   
    @IBOutlet weak var Cam: UIButton!
    @IBOutlet weak var totalCalories: UILabel!
    
    @IBOutlet weak var totalFats: UILabel!
    
    @IBOutlet weak var totalCarbs: UILabel!
    
    @IBOutlet weak var totalProteins: UILabel!
    
    @IBAction func scan(_ sender: Any) {
        self.totalCalories.isHidden = true
        self.totalFats.isHidden = true
        self.totalCarbs.isHidden = true
        self.totalProteins.isHidden = true
        checkPermissions()
        setupCameraLiveView()
        addShutterButton()
        Cam.isHidden = true
    }
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: { (request, error) in
            guard error == nil else {
                self.showAlert(withTitle: "Barcode Error", message: error!.localizedDescription)
                return
            }

            self.processClassification(for: request)
        })
    }()

    
    struct Nutrition : Decodable {
        var carbohydrates : Int
        var energy_value : Float
        var fat : Int
        var proteins: Int
    }
    
    struct Wrapper: Decodable {
        var nutriments : Nutrition
    }
    
    struct ProductWrapper: Decodable {
        var product: Wrapper
    }
    enum CustomError: String, Error {

        case invalidResponse = "The response from the server was invalid."
        case invalidData = "The data received from the server was invalid."

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   

    }

    override func viewDidAppear(_ animated: Bool) {
        // Every time the user re-enters the app, we must be sure we have access to the camera.
        checkPermissions()
    }

    // MARK: - User interface
    override var prefersStatusBarHidden: Bool {
        return true
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Camera
    private func checkPermissions() {
        let mediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)

        switch status {
        case .denied, .restricted:
            displayNotAuthorizedUI()
        case.notDetermined:
            // Prompt the user for access.
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                guard granted != true else { return }

                // The UI must be updated on the main thread.
                DispatchQueue.main.async {
                    self.displayNotAuthorizedUI()
                }
            }

        default: break
        }
    }

    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    private func setupCameraLiveView() {
        // Set up the camera session.
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720

        // Set up the video device.
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],mediaType: AVMediaType.video,
          position: .back)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
        }

        // Make sure the actually is a back camera on this particular iPhone.
        guard let backCamera = backCamera else {
            showAlert(withTitle: "Camera error", message: "There seems to be no camera on your device.")
            return
        }

        // Set up the input and output stream.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(captureDeviceInput)
        } catch {
            showAlert(withTitle: "Camera error", message: "Your camera can't be used as an input device.")
            return
        }

        // Initialize the capture output and add it to the session.
        captureOutput = AVCapturePhotoOutput()
        captureOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(captureOutput!)

        // Add a preview layer.
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer!.videoGravity = .resizeAspectFill
        cameraPreviewLayer!.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = view.frame

        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)

        // Start the capture session.
        captureSession.startRunning()
    }

    @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        captureOutput?.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) {

            // Convert image to CIImage.
            guard let ciImage = CIImage(image: image) else {
                fatalError("Unable to create \(CIImage.self) from \(image).")
            }

            // Perform the classification request on a background thread.
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])

                do {
                    try handler.perform([self.detectBarcodeRequest])
                } catch {
                    self.showAlert(withTitle: "Error Decoding Barcode", message: error.localizedDescription)
                }
            }
        }
    }

    // MARK: - User interface
    private func displayNotAuthorizedUI() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: 20))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Please grant access to the camera for scanning barcodes."
        label.sizeToFit()

        let button = UIButton(frame: CGRect(x: 0, y: label.frame.height + 8, width: view.frame.width * 0.8, height: 35))
        button.layer.cornerRadius = 10
        button.setTitle("Grant Access", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 4.0/255.0, green: 92.0/255.0, blue: 198.0/255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let containerView = UIView(frame: CGRect(
            x: view.frame.width * 0.1,
            y: (view.frame.height - label.frame.height + 8 + button.frame.height) / 2,
            width: view.frame.width * 0.8,
            height: label.frame.height + 8 + button.frame.height
            )
        )
        containerView.addSubview(label)
        containerView.addSubview(button)
        view.addSubview(containerView)
    }

    private func addShutterButton() {
        let width: CGFloat = 75
        let height = width
        shutterButton = UIButton(frame: CGRect(x: (view.frame.width - width) / 2,
                                               y: view.frame.height - height - 55,
                                               width: width,
                                               height: height
            )
        )
        shutterButton.layer.cornerRadius = width / 2
        shutterButton.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        shutterButton.showsTouchWhenHighlighted = true
        shutterButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        view.addSubview(shutterButton)
    }

    private func showInfo(for payload: String) {

        
        self.found(code: payload)
    }

    // MARK: - Vision
    func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
                let payload = bestResult.payloadStringValue {
                self.showInfo(for: payload)
            } else {
                self.showAlert(withTitle: "Unable to extract results",
                               message: "Cannot extract barcode information from data.")
            }
        }
    }

    // MARK: - Helper functions
    @objc private func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { _ in
            self.checkPermissions()
        }
    }

    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    
    
    func found(code: String) {
      
        //print (code)
        let s = "https://world.openfoodfacts.org/api/v0/product/\(code).json"
        self.request( urlString: s)
        //showAlert(withTitle: String(product.nutriments.energy_value) , message: "error")
    }
    
    func request(urlString : String ){

        if let url = URL(string: urlString){

            let session = URLSession(configuration: .default)

            let task = session.dataTask(with :url) { (data , response , error) in

                if(error != nil){
                    print(error!)
                }

                    if let safeData = data{

                        //print(safeData)
                        self.parseFunc(inputData: safeData)
                    }

            }
            task.resume()
        }

    }


    func parseFunc(inputData : Data){

        let decoder = JSONDecoder()


        do{
            let decoded = try decoder.decode(ProductWrapper.self, from: inputData)
            let product = decoded.product
            print(decoded.product.nutriments.carbohydrates,"sa")
            DispatchQueue.main.async { () -> Void in
//                self.showAlert(withTitle: "Calories:" , message: String(round(product.nutriments.energy_value/4.104)))
                self.calories = Int(Float(round(product.nutriments.energy_value/4.104)))
                self.carbs = product.nutriments.carbohydrates
                self.fats = product.nutriments.fat
                self.proteins = product.nutriments.proteins
                
                self.popoverPresentationController
                self.navigationController?.popViewController(animated: true)

                self.cameraPreviewLayer?.isHidden = true
                self.Cam.isHidden = false
                self.shutterButton.removeFromSuperview()

                self.stopSession()
                self.totalCalories.isHidden = false
                self.totalFats.isHidden = false
                self.totalCarbs.isHidden = false
                self.totalProteins.isHidden = false
                self.totalCalories.text = "Total Calories: " + String(self.calories)
                self.totalFats.text = "Total Fats: " + String(self.fats)
                self.totalCarbs.text = "Total Carbs: " + String(self.carbs)
                self.totalProteins.text = "Total Proteins: " + String(self.proteins)
        
               
         }
         

          

        }catch{
            print(error)
        }

    }
}
