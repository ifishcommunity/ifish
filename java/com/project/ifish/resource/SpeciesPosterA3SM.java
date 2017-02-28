package com.project.ifish.resource;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.Barcode128;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.project.general.DbFile;
import com.project.general.DbSystemProperty;
import com.project.general.File;
import com.project.ifish.master.DbFish;
import com.project.ifish.master.Fish;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.Hashtable;
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
public class SpeciesPosterA3SM extends HttpServlet {

    public SpeciesPosterA3SM() {
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
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD, BaseColor.BLACK);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, BaseColor.BLACK);
    Font header = FontFactory.getFont("sans-serif", 12, Font.BOLD, BaseColor.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Document document = new Document(PageSize.A3.rotate(), 20, 20, 40, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            document.open();
            getPdf(document, writer);

        } catch (Exception e) {
            System.out.println("Exception draw pdf : " + e.toString());
        }

        document.close();

        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setHeader("content-disposition", "filename=SpeciesPosterA3SM.pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    public static void getPdf(Document document, PdfWriter writer) throws BadElementException, DocumentException {
        try {
            Vector listFish = DbFish.list(0, 0, "", "");
            Hashtable hFishID = new Hashtable();
            if (listFish != null && listFish.size() > 0) {
                for (int i = 0; i < listFish.size(); i++) {
                    Fish fish = (Fish) listFish.get(i);
                    hFishID.put(String.valueOf(fish.getFishID()), fish);
                }
            }

            Hashtable hFishCode = new Hashtable();
            if (listFish != null && listFish.size() > 0) {
                for (int i = 0; i < listFish.size(); i++) {
                    Fish fish = (Fish) listFish.get(i);
                    hFishCode.put(String.valueOf(fish.getFishCode()), fish);
                }
            }

            Vector listFile = DbFile.list(0, 0, DbFile.colNames[DbFile.COL_REF_ID] + "!=0", "");
            Hashtable hFile = new Hashtable();
            if (listFile != null && listFile.size() > 0) {
                for (int i = 0; i < listFile.size(); i++) {
                    File file = (File) listFile.get(i);
                    hFile.put(file.getOID(), file);
                }
            }

            String[] selectedFishID = {
                //PAGE-1
                "1", "2", "3", "4", "5",
                "6", "7", "8", "9", "10",
                "11", "12", "13", "14", "15",
                "16", "17", "18", "19", "20",
                "21", "22", "23", "24", "27",
                //PAGE-2
                "25", "26", "28", "29", "30",
                "31", "32", "33", "34", "35",
                "36", "37", "38", "39", "40",
                "41", "42", "43", "44", "45",
                "46", "47", "48", "49", "50",
                //PAGE-3
                "51", "52", "53", "54", "55",
                "56", "57", "58", "59", "60",
                "61", "62", "63", "64", "65",
                "66", "67", "68", "69", "70",
                "71", "72", "73", "74", "75",
                //PAGE-4
                "76", "77", "78", "79", "80",
                "81", "82", "83", "84", "85",
                "86", "87", "88", "89", "90",
                "91", "92", "93", "94", "95",
                "96", "97", "98", "99", "100",
                //PAGE-5
                "101", "102", "103", "104", "105",
                "106", "107", "108", "109", "110",
                "111", "112", "113", "114", "115",
                "116", "117", "118", "119", "120",
                "", "", "", "", ""
            };

            String[] selectedFishCode = {
                //PAGE-6
                "FC050", "FC041", "FC051", "FC052", "FC007",
                "FC056", "FC053", "FC022", "FC054", "FC055",
                "FC032", "OO001", "", "", ""
            };

            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setWidths(new int[]{20, 20, 20, 20, 20});
            PdfPCell cell = new PdfPCell(new Phrase("120 Species identification guide for deepwater hook-and-line fisheries targeting snappers and groupers in Indonesia", fontHeader));
            cell.setColspan(5);
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell = new PdfPCell(new Phrase(" "));
            cell.setColspan(5);
            cell.setBorder(0);
            table.addCell(cell);

            table.setHeaderRows(2);

            //FISH ID
            for (int i = 0; i < selectedFishID.length; i++) {
                // get fish
                Fish fish = (Fish) hFishID.get(selectedFishID[i]);
                if (fish == null) {
                    fish = new Fish();
                }

                generateTable(writer, table, hFile, fish);
            }

            //FAMILY ID
            for (int i = 0; i < selectedFishCode.length; i++) {
                // get fish
                Fish fish = (Fish) hFishCode.get(selectedFishCode[i]);
                if (fish == null) {
                    fish = new Fish();
                }

                generateTable(writer, table, hFile, fish);
            }

            document.add(table);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    private static void generateTable(PdfWriter writer, PdfPTable table, Hashtable hFile, Fish fish) {
        try {
            // get file
            File file = new File();
            if (fish.getOID() != 0) {
                file = (File) hFile.get(fish.getDefaultPictureId());
                if (file == null) {
                    file = new File();
                }
            }

            // get fish id picture
            String imgPath = DbSystemProperty.getValueByName("APP_PATH") + "files" + System.getProperty("file.separator") + file.getName();
            Image imgFish = null;
            try {
                imgFish = Image.getInstance(imgPath);
                imgFish.setAlignment(Image.RIGHT);
            } catch (Exception e) {
                System.out.println(e.toString() + " " + imgPath);
            }

            // generate barcode
            PdfContentByte cb = writer.getDirectContent();
            Barcode128 code128 = new Barcode128();
            code128.setCode(fish.getInsiteCode());
            code128.setBarHeight(12f);
            code128.setX(1.1f);

            // create label
            String label = "";
            if (fish.isFamilyID() == 1) {
                label = fish.getFishFamily();
            } else {
                label = fish.getFishGenus() + " " + fish.getFishSpecies();
            }

            // create table for each species
            PdfPTable table1 = new PdfPTable(1);
            table1.setWidthPercentage(100);
            table1.setWidths(new int[]{100});
            PdfPCell cell1 = new PdfPCell(new Phrase(label, fontContent));
            cell1.setBorder(0);
            cell1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table1.addCell(cell1);

            cell1 = new PdfPCell(new Phrase(" "));
            if (imgFish != null) {
                cell1.addElement(imgFish);
            }
            cell1.setVerticalAlignment(PdfPCell.ALIGN_CENTER);
            cell1.setBorder(0);
            cell1.setFixedHeight(100f);
            table1.addCell(cell1);

            if (fish.getOID() == 0) {
                cell1 = new PdfPCell(new Phrase(" "));
            } else {
                cell1 = new PdfPCell(code128.createImageWithBarcode(cb, null, null));
            }
            cell1.setBorder(PdfPCell.TOP | PdfPCell.RIGHT | PdfPCell.BOTTOM | PdfPCell.LEFT);
            cell1.setPadding(3);
            cell1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell1.setBorder(0);
            table1.addCell(cell1);

            PdfPCell cell = new PdfPCell(new Phrase(""));
            cell.setBorder(0);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.addElement(table1);
            table.addCell(cell);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
