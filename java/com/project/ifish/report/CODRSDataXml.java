package com.project.ifish.report;

import com.project.ifish.data.DbDeepSlope;
import com.project.ifish.data.DbSizing;
import com.project.ifish.data.DeepSlope;
import com.project.ifish.data.Sizing;
import com.project.ifish.master.Boat;
import com.project.ifish.master.DbBoat;
import com.project.ifish.master.DbFish;
import com.project.ifish.master.DbTracker;
import com.project.ifish.master.Fish;
import com.project.ifish.master.Tracker;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.zip.GZIPOutputStream;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.project.util.jsp.JSPRequestValue;
import com.project.util.JSPFormater;
import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class CODRSDataXml extends HttpServlet {

    /** Initializes the servlet.
     */
    public static String formatDate = "dd MMMM yyyy";

    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {
    }

    String XMLSafe(String in) {
        return in;
        //return HTMLEncoder.encode(in);
    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     *
     * Why not use a DOM? Because we want to be able to create the spreadsheet on-the-fly, without
     * having to use up a lot of memory before hand
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        response.setContentType("application/x-msexcel");
        boolean gzip = false;

        //response.setCharacterEncoding( "UTF-8" ) ;
        OutputStream gzo;
        if (gzip) {
            response.setHeader("Content-Encoding", "gzip");
            gzo = new GZIPOutputStream(response.getOutputStream());
        } else {
            gzo = response.getOutputStream();
        }

        try {
            long landingId = JSPRequestValue.requestLong(request, "landing_id");
            DeepSlope deepSlope = DbDeepSlope.fetchExc(landingId);
            Boat boat = new Boat();
            Tracker tracker = new Tracker();
            Vector listSpecimen = null;
            Vector listFish = DbFish.listAll();
            Hashtable hFish = new Hashtable();
            if (listFish != null && listFish.size() > 0) {
                for (int i = 0; i < listFish.size(); i++) {
                    Fish fish = (Fish) listFish.get(i);
                    hFish.put(fish.getOID(), fish);
                }
            }

            if (deepSlope.getOID() > 0) {
                String order = DbSizing.colNames[DbSizing.COL_CODRS_PICTURE_DATE] + ", " + DbSizing.colNames[DbSizing.COL_CODRS_PICTURE_NAME];
                listSpecimen = DbSizing.list(0, 0, DbSizing.colNames[DbSizing.COL_LANDING_ID] + "=" + deepSlope.getOID(), order);
                boat = DbBoat.fetchExc(deepSlope.getBoatId());
                tracker = DbTracker.getByTrackerId(boat.getTrackerId());
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
                response.setHeader("Content-Disposition", "filename=CODRS-"+boat.getName().trim().replaceAll("\\ ", "")+"-"+sdf.format(deepSlope.getLandingDate())+".xls");
            }

            PrintWriter wb = new PrintWriter(new OutputStreamWriter(gzo, "UTF-8"));
            wb.println("<?xml version=\"1.0\"?>");
            wb.println("<?mso-application progid=\"Excel.Sheet\"?>");
            wb.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            wb.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
            wb.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
            wb.println(" xmlns:dt=\"uuid:C2F41010-65B3-11d1-A29F-00AA00C14882\"");
            wb.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            wb.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
            wb.println(" <DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
            wb.println("  <Author>gwawan</Author>");
            wb.println("  <LastAuthor>gwawan</LastAuthor>");
            wb.println("  <Created>2015-11-18T05:26:51Z</Created>");
            wb.println("  <LastSaved>2015-12-05T02:30:11Z</LastSaved>");
            wb.println("  <Company>Toshiba</Company>");
            wb.println("  <Version>14.00</Version>");
            wb.println(" </DocumentProperties>");
            wb.println(" <CustomDocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
            wb.println("  <TBCO_ScreenResolution dt:dt=\"string\">96 96 1366 768</TBCO_ScreenResolution>");
            wb.println(" </CustomDocumentProperties>");
            wb.println(" <OfficeDocumentSettings xmlns=\"urn:schemas-microsoft-com:office:office\">");
            wb.println("  <AllowPNG/>");
            wb.println(" </OfficeDocumentSettings>");
            wb.println(" <ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
            wb.println("  <WindowHeight>7740</WindowHeight>");
            wb.println("  <WindowWidth>20115</WindowWidth>");
            wb.println("  <WindowTopX>240</WindowTopX>");
            wb.println("  <WindowTopY>45</WindowTopY>");
            wb.println("  <ProtectStructure>False</ProtectStructure>");
            wb.println("  <ProtectWindows>False</ProtectWindows>");
            wb.println(" </ExcelWorkbook>");
            wb.println(" <Styles>");
            wb.println("  <Style ss:ID=\"Default\" ss:Name=\"Normal\">");
            wb.println("   <Alignment ss:Vertical=\"Bottom\"/>");
            wb.println("   <Borders/>");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"/>");
            wb.println("   <Interior/>");
            wb.println("   <NumberFormat/>");
            wb.println("   <Protection/>");
            wb.println("  </Style>");
            wb.println("  <Style ss:ID=\"s62\">");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"11\" ss:Color=\"#000000\"");
            wb.println("    ss:Bold=\"1\"/>");
            wb.println("  </Style>");
            wb.println("  <Style ss:ID=\"s63\">");
            wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
            wb.println("   <Borders/>");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
            wb.println("  </Style>");
            wb.println("  <Style ss:ID=\"s65\">");
            wb.println("   <Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Bottom\"/>");
            wb.println("   <Borders/>");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
            wb.println("   <NumberFormat ss:Format=\"yyyy\\-mm\\-dd\"/>");
            wb.println("  </Style>");
            wb.println("  <Style ss:ID=\"s66\">");
            wb.println("   <Alignment ss:Horizontal=\"Left\" ss:Vertical=\"Bottom\"/>");
            wb.println("   <Borders/>");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\"/>");
            wb.println("  </Style>");
            wb.println("  <Style ss:ID=\"s67\">");
            wb.println("   <Font ss:FontName=\"Calibri\" x:Family=\"Swiss\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
            wb.println("  </Style>");
            wb.println(" </Styles>");
            wb.println(" <Worksheet ss:Name=\"Sheet1\">");
            wb.println("  <Table ss:ExpandedColumnCount=\"15\" x:FullColumns=\"1\" x:FullRows=\"1\" ss:DefaultRowHeight=\"15\">"); //ss:ExpandedRowCount=\"2\" 
            wb.println("   <Column ss:Width=\"62.25\"/>");
            wb.println("   <Column ss:Width=\"72\"/>");
            wb.println("   <Column ss:Width=\"62.25\"/>");
            wb.println("   <Column ss:Width=\"75.75\"/>");
            wb.println("   <Column ss:Width=\"55.5\"/>");
            wb.println("   <Column ss:Width=\"60.75\"/>");
            wb.println("   <Column ss:Width=\"78\"/>");
            wb.println("   <Column ss:Width=\"66\"/>");
            wb.println("   <Column ss:Width=\"74.25\"/>");
            wb.println("   <Column ss:Width=\"33\" ss:Span=\"2\"/>");
            wb.println("   <Column ss:Index=\"13\" ss:Width=\"123.75\"/>");
            wb.println("   <Column ss:Width=\"60.75\"/>");
            wb.println("   <Row>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">FISHING GEAR</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">LANDING DATE</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">WPP1</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">WPP2</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">WPP3</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">OTHER FISHING GROUND</Data></Cell>");
            wb.println("   </Row>");
            wb.println("   <Row ss:Height=\"15.75\">");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + deepSlope.getFishingGear() + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s65\"><Data ss:Type=\"DateTime\">" + JSPFormater.formatDate(deepSlope.getLandingDate(), "yyyy-MM-dd") + "T00:00:00.000</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + deepSlope.getWpp1() + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + deepSlope.getWpp2() + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + deepSlope.getWpp3() + "</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + deepSlope.getOtherFishingGround() + "</Data></Cell>");
            wb.println("   </Row>");
            wb.println("   <Row ss:Height=\"15.75\">");
            wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\"></Data></Cell>");
            wb.println("   </Row>");
            wb.println("   <Row>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PICTURE DATE</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">PICTURE NAME</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">FAMILY</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">GENUS</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">SPECIES</Data></Cell>");
            wb.println("    <Cell ss:StyleID=\"s62\"><Data ss:Type=\"String\">TOTAL LENGTH</Data></Cell>");
            wb.println("   </Row>");

            if (listSpecimen != null && listSpecimen.size() > 0) {
                for (int i = 0; i < listSpecimen.size(); i++) {
                    Sizing sizing = (Sizing) listSpecimen.get(i);
                    Fish fish = (Fish) hFish.get(sizing.getFishId());
                    if (fish == null) {
                        fish = new Fish();
                    }

                    wb.println("   <Row ss:Height=\"15.75\">");
                    wb.println("    <Cell ss:StyleID=\"s65\"><Data ss:Type=\"DateTime\">" + JSPFormater.formatDate(sizing.getCODRSPictureDate(), "yyyy-MM-dd") + "T00:00:00.000</Data></Cell>");
                    wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"String\">" + sizing.getCODRSPictureName() + "</Data></Cell>");
                    wb.println("    <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + fish.getFishFamily() + "</Data></Cell>");
                    wb.println("    <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + fish.getFishGenus() + "</Data></Cell>");
                    wb.println("    <Cell ss:StyleID=\"s66\"><Data ss:Type=\"String\">" + fish.getFishSpecies() + "</Data></Cell>");
                    wb.println("    <Cell ss:StyleID=\"s63\"><Data ss:Type=\"Number\">" + sizing.getCm() + "</Data></Cell>");
                    wb.println("   </Row>");
                }
            }
            wb.println("  </Table>");
            wb.println("  <WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
            wb.println("   <PageSetup>");
            wb.println("    <Header x:Margin=\"0.3\"/>");
            wb.println("    <Footer x:Margin=\"0.3\"/>");
            wb.println("    <PageMargins x:Bottom=\"0.75\" x:Left=\"0.7\" x:Right=\"0.7\" x:Top=\"0.75\"/>");
            wb.println("   </PageSetup>");
            wb.println("   <Print>");
            wb.println("    <ValidPrinterInfo/>");
            wb.println("    <PaperSizeIndex>0</PaperSizeIndex>");
            wb.println("    <HorizontalResolution>203</HorizontalResolution>");
            wb.println("    <VerticalResolution>203</VerticalResolution>");
            wb.println("   </Print>");
            wb.println("   <Selected/>");
            wb.println("   <FreezePanes/>");
            wb.println("   <FrozenNoSplit/>");
            wb.println("   <SplitHorizontal>4</SplitHorizontal>");
            wb.println("   <TopRowBottomPane>4</TopRowBottomPane>");
            wb.println("   <ActivePane>2</ActivePane>");
            wb.println("   <Panes>");
            wb.println("    <Pane>");
            wb.println("     <Number>3</Number>");
            wb.println("    </Pane>");
            wb.println("    <Pane>");
            wb.println("     <Number>2</Number>");
            wb.println("    </Pane>");
            wb.println("   </Panes>");
            wb.println("   <ProtectObjects>False</ProtectObjects>");
            wb.println("   <ProtectScenarios>False</ProtectScenarios>");
            wb.println("  </WorksheetOptions>");
            wb.println(" </Worksheet>");
            wb.println("</Workbook>");
            wb.flush();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Servlet to get CODRS data.";
    }
}
