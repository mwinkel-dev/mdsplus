/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author mdsplus
 */
public class MARTE2_WRTDTIMERSetup extends DeviceSetup {

    /**
     * Creates new form MARTE2_WRTDTIMERSetup
     */
    public MARTE2_WRTDTIMERSetup() {
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        deviceButtons1 = new DeviceButtons();
        jPanel2 = new javax.swing.JPanel();
        jPanel3 = new javax.swing.JPanel();
        deviceChoice1 = new DeviceChoice();
        deviceField1 = new DeviceField();
        deviceField5 = new DeviceField();
        jPanel4 = new javax.swing.JPanel();
        deviceField2 = new DeviceField();
        deviceField3 = new DeviceField();
        deviceField4 = new DeviceField();
        jPanel5 = new javax.swing.JPanel();
        deviceField6 = new DeviceField();
        deviceField7 = new DeviceField();
        deviceField8 = new DeviceField();
        jPanel1 = new javax.swing.JPanel();

        setDeviceProvider("localhost:8100");
        setDeviceTitle("WRTD Timer ");
        setDeviceType("MARTE2_WRTDTIMER");
        setHeight(200);
        setWidth(700);
        getContentPane().add(deviceButtons1, java.awt.BorderLayout.PAGE_END);

        jPanel2.setLayout(new java.awt.GridLayout(3, 0));

        deviceChoice1.setChoiceItems(new String[] {"CLOCK_TAI", "CLOCK_REALTIME", "CLOCK_MONOTONIC", "CLOCK_PTP"});
        deviceChoice1.setIdentifier("");
        deviceChoice1.setLabelString("Clock Mode: ");
        deviceChoice1.setOffsetNid(7);
        deviceChoice1.setUpdateIdentifier("");
        jPanel3.add(deviceChoice1);

        deviceField1.setIdentifier("");
        deviceField1.setLabelString("Event Name (reg.expr.):");
        deviceField1.setOffsetNid(16);
        deviceField1.setTextOnly(true);
        jPanel3.add(deviceField1);

        deviceField5.setIdentifier("");
        deviceField5.setLabelString("CPU Mask: ");
        deviceField5.setNumCols(4);
        deviceField5.setOffsetNid(10);
        jPanel3.add(deviceField5);

        jPanel2.add(jPanel3);

        deviceField2.setIdentifier("");
        deviceField2.setLabelString("UDP Port:");
        deviceField2.setNumCols(5);
        deviceField2.setOffsetNid(13);
        jPanel4.add(deviceField2);

        deviceField3.setIdentifier("");
        deviceField3.setLabelString("Multicast Group");
        deviceField3.setOffsetNid(19);
        deviceField3.setTextOnly(true);
        jPanel4.add(deviceField3);

        deviceField4.setIdentifier("");
        deviceField4.setLabelString("Leap Seconds: ");
        deviceField4.setNumCols(4);
        deviceField4.setOffsetNid(22);
        jPanel4.add(deviceField4);

        jPanel2.add(jPanel4);

        deviceField6.setIdentifier("");
        deviceField6.setLabelString("Perios(s): ");
        deviceField6.setNumCols(6);
        deviceField6.setOffsetNid(31);
        jPanel5.add(deviceField6);

        deviceField7.setIdentifier("");
        deviceField7.setLabelString("Delay(s):");
        deviceField7.setNumCols(6);
        deviceField7.setOffsetNid(25);
        jPanel5.add(deviceField7);

        deviceField8.setIdentifier("");
        deviceField8.setLabelString("Phase(s): ");
        deviceField8.setNumCols(6);
        deviceField8.setOffsetNid(28);
        jPanel5.add(deviceField8);

        jPanel2.add(jPanel5);

        getContentPane().add(jPanel2, java.awt.BorderLayout.PAGE_START);
        getContentPane().add(jPanel1, java.awt.BorderLayout.CENTER);
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private DeviceButtons deviceButtons1;
    private DeviceChoice deviceChoice1;
    private DeviceField deviceField1;
    private DeviceField deviceField2;
    private DeviceField deviceField3;
    private DeviceField deviceField4;
    private DeviceField deviceField5;
    private DeviceField deviceField6;
    private DeviceField deviceField7;
    private DeviceField deviceField8;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    // End of variables declaration//GEN-END:variables
}