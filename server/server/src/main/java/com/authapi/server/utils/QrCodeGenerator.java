package com.authapi.server.utils;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

public class QrCodeGenerator {
    private static final int WIDTH = 300;
    private static final int LENGTH = 300;

    public static BufferedImage generateQrImage(String payload) throws WriterException {
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(payload, BarcodeFormat.QR_CODE, WIDTH, LENGTH);
        return MatrixToImageWriter.toBufferedImage(bitMatrix);
    }

    public static String generateQrBase64(String payload) throws WriterException, IOException {
        BufferedImage qrImage = generateQrImage(payload);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        javax.imageio.ImageIO.write(qrImage, "png", baos);
        byte[] pngBytes = baos.toByteArray();
        return Base64.getEncoder().encodeToString(pngBytes);
    }
}
