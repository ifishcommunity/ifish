package com.project.ifish.resource;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.Barcode128;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.project.ifish.master.DbFish;
import com.project.ifish.master.Fish;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gwawan
 */
public class InsiteSpeciesBarcodePdf extends HttpServlet {

    public InsiteSpeciesBarcodePdf() {
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /** Destroys the servlet.
     */
    @Override
    public void destroy() {
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servle t request
     * @param response servlet response
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);
    public static Color headerColor = new Color(232, 232, 238);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, BaseColor.BLACK);
    public static Font fontHeaderB = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, BaseColor.BLACK);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, BaseColor.BLACK);
    public static Font fontContentB = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, BaseColor.BLACK);
    public static Font fontHeaderFooter = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, BaseColor.BLACK);
    Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Document document = new Document(PageSize.A4, 10, 20, 20, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            String order = DbFish.colNames[DbFish.COL_IS_FAMILY_ID]+", "+DbFish.colNames[DbFish.COL_FISH_ID];
            Vector list = DbFish.list(0, 0, "", order);
            document.open();
            getPdf(document, writer, list);

        } catch (Exception e) {
            System.out.println("Exception draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "filename=insitespeciesbarcode.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer, Vector list) throws BadElementException, DocumentException {
        try {
            int cellCounter = 0;
            int rowNumber = 3;
            PdfPTable table = new PdfPTable(rowNumber);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{33, 34, 33});
            PdfPCell cell;

            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Fish fish = (Fish) list.get(i);
                    if (fish.getInsiteCode().trim().length() > 0) {
                        String label = "";
                        if (fish.isFamilyID() == 1) {
                            label = fish.getFishFamily();
                        } else {
                            label = fish.getFishGenus() + " " + fish.getFishSpecies();
                        }

                        PdfContentByte cb = writer.getDirectContent();
                        Barcode128 code128 = new Barcode128();
                        code128.setCode(fish.getInsiteCode());
                        code128.setBarHeight(16f);
                        code128.setX(1f);
                        code128.setAltText(label);
                        cell = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
                        cell.setBorder(PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM | PdfPCell.LEFT);
                        cell.setPadding(3);
                        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                        table.addCell(cell);
                        cellCounter++;
                    }
                }
            }

            // complete lack of cell
            int loop = rowNumber - (cellCounter % rowNumber);
            for(int n = 0; n < loop; n++) {
                cell = new PdfPCell(new Phrase(" "));
                cell.setBorder(PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM | PdfPCell.LEFT);
                cell.setPadding(5);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
                table.addCell(cell);
            }

            document.add(table);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
